class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :client
  belongs_to :note, optional: true

  validates :log_type, :content, presence: true
end
