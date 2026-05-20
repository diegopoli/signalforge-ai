class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :clients, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :ai_tasks, dependent: :destroy
end
