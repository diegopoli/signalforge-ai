class EmbedDocumentJob < ApplicationJob
  queue_as :ai

  def perform(document_id)
    document = Document.find(document_id)
    embedding = Ai::Embeddings.new.call(text: document.content)
    document.update!(embedding: embedding, status: "embedded")
  rescue StandardError
    document.update!(status: "failed") if document
    raise
  end
end
