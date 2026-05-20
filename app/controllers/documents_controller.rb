class DocumentsController < ApplicationController
  def index
    @documents = current_user.documents.order(created_at: :desc)
    @document = current_user.documents.new
    @clients = current_user.clients.order(:full_name)
  end

  def new
    @document = current_user.documents.new
    @clients = current_user.clients.order(:full_name)
  end

  def create
    @document = current_user.documents.new(document_params)
    @document.status = "ready"
    @document.source_type = params[:client_id].present? ? "client_doc" : "advisor_doc"

    if @document.save
      EmbedDocumentJob.perform_later(@document.id)
      redirect_to documents_path, notice: "Document saved and queued for embedding."
    else
      @documents = current_user.documents.order(created_at: :desc)
      @clients = current_user.clients.order(:full_name)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def document_params
    params.require(:document).permit(:title, :content, :client_id)
  end
end
