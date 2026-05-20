class ProcessNoteJob < ApplicationJob
  queue_as :ai

  def perform(note_id)
    note = Note.find(note_id)
    Ai::MeetingProcessor.new(note: note).call
  end
end
