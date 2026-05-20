class NotesController < ApplicationController
  def create
    client = current_user.clients.find(params[:client_id])
    note = client.notes.new(note_params.merge(user: current_user, processing_status: :pending))

    if note.save
      ProcessNoteJob.perform_later(note.id)
      redirect_to client_path(client), notice: "Note uploaded. AI processing has started."
    else
      redirect_to client_path(client), alert: note.errors.full_messages.to_sentence
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :source_type, :raw_content)
  end
end
