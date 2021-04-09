class Comment < ApplicationRecord
  include HasAuthor

  default_scope -> { order(created_at: :asc) }

  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
