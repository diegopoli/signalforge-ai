class Client < ApplicationRecord
  belongs_to :user

  has_many :notes, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :ai_tasks, dependent: :destroy

  validates :full_name, :email, presence: true

  scope :recent, -> { order(updated_at: :desc) }
end
