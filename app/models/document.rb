class Document < ApplicationRecord
  belongs_to :user
  belongs_to :client, optional: true

  validates :title, :content, presence: true

  scope :for_user, ->(user) { where(user_id: user.id) }

  def self.semantic_search(user:, embedding:, limit: 5)
    numeric_embedding = Array(embedding).map { |value| Float(value) }
    vector_literal = "[#{numeric_embedding.join(",")}]"

    for_user(user)
      .where.not(embedding: nil)
      .order(Arel.sql("embedding <=> '#{vector_literal}'"))
      .limit(limit)
  rescue ArgumentError, TypeError
    none
  end
end
