class AiTask < ApplicationRecord
  enum :status, {
    queued: "queued",
    running: "running",
    completed: "completed",
    failed: "failed"
  }, default: :queued

  belongs_to :user
  belongs_to :client, optional: true
  belongs_to :note, optional: true

  validates :task_type, presence: true
end
