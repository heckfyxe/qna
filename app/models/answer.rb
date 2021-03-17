class Answer < ApplicationRecord
  default_scope -> { order(the_best: :desc, created_at: :asc) }
  scope :the_best, -> { where(the_best: true) }

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true
  validate { errors.add(:base, 'Question can have only one the best answer') unless question.answers.the_best.count <= 1 }
end
