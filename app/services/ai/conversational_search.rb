module Ai
  class ConversationalSearch
    def initialize(user:, query:)
      @user = user
      @query = query
      @api_client = ClientFactory.build
    end

    def call
      context = rag_context

      response = @api_client.chat(
        parameters: {
          model: ProviderConfig.chat_model,
          messages: [
            {
              role: "system",
              content: "You are a CRM copilot for financial advisors. Answer with practical clarity and reference specific client context when available."
            },
            {
              role: "user",
              content: "Question: #{@query}\n\nContext:\n#{context}"
            }
          ],
          temperature: 0.2
        }
      )

      response.dig("choices", 0, "message", "content") || "No response"
    end

    private

    def rag_context
      return "RAG disabled by feature flag." unless ProviderConfig.rag_enabled?

      embedding = Embeddings.new.call(text: @query)
      return "No vector context available." if embedding.blank?

      docs = Document.semantic_search(user: @user, embedding: embedding, limit: 5)
      return "No matching advisor documents found." if docs.none?

      docs.map do |doc|
        "[#{doc.title}] #{doc.content.truncate(400)}"
      end.join("\n\n")
    rescue StandardError
      "Context retrieval failed, answer based on general CRM best practices."
    end
  end
end
