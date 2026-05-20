class Note < ApplicationRecord
  enum :processing_status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed"
  }, default: :pending

  belongs_to :user
  belongs_to :client

  validates :raw_content, presence: true
end
