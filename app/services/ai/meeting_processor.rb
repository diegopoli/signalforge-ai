module Ai
  class MeetingProcessor
    SYSTEM_PROMPT = <<~PROMPT.freeze
      You are an expert CRM operations assistant for financial advisors.
      Keep output concise and practical.
      Return valid JSON with keys: summary, action_items, email_draft.
    PROMPT

    def initialize(note:)
      @note = note
      @client = note.client
      @user = note.user
      @api_client = ClientFactory.build
    end

    def call
      @note.processing!
      task = AiTask.create!(
        user: @user,
        client: @client,
        note: @note,
        task_type: "meeting_post_processing",
        status: :running,
        input_payload: { raw_content: @note.raw_content }
      )

      response = @api_client.chat(
        parameters: {
          model: ProviderConfig.chat_model,
          response_format: { type: "json_object" },
          messages: [
            { role: "system", content: SYSTEM_PROMPT },
            { role: "user", content: user_prompt }
          ],
          temperature: 0.2
        }
      )

      payload = JSON.parse(response.dig("choices", 0, "message", "content") || "{}")

      @note.update!(
        summary: payload["summary"],
        action_items: payload["action_items"],
        email_draft: payload["email_draft"],
        processing_status: :completed
      )

      task.update!(status: :completed, output_payload: payload)

      ActivityLog.create!(
        user: @user,
        client: @client,
        note: @note,
        log_type: "ai_summary_generated",
        content: "AI generated summary, tasks, and follow-up draft from latest note.",
        metadata: { note_id: @note.id }
      )
    rescue StandardError => e
      @note.update!(processing_status: :failed)
      task&.update!(status: :failed, error_message: e.message)
      raise
    end

    private

    def user_prompt
      <<~PROMPT
        Client: #{@client.full_name}
        Advisor Note/Transcript:
        #{@note.raw_content}

        Generate:
        1) a concise summary
        2) bullet-style action items
        3) a professional follow-up email draft
      PROMPT
    end
  end
end
