class DashboardController < ApplicationController
  def index
    @clients_count = current_user.clients.count
    @notes_count = current_user.notes.count
    @documents_count = current_user.documents.count
    @recent_logs = current_user.activity_logs.order(created_at: :desc).limit(8)
  end
end
