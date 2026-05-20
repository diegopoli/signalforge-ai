class AiAssistantController < ApplicationController
  def show
    @answer = nil
    @query = nil
  end

  def search
    @query = params[:query].to_s.strip

    if @query.blank?
      redirect_to ai_assistant_path, alert: "Enter a question first."
      return
    end

    @answer = Ai::ConversationalSearch.new(user: current_user, query: @query).call
    render :show
  rescue StandardError => e
    Rails.logger.error("AI assistant failed for user=#{current_user.id}: #{e.class} #{e.message}")
    redirect_to ai_assistant_path, alert: "AI assistant is temporarily unavailable."
  end
end
