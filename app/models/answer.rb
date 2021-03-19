class Answer < ApplicationRecord
  default_scope -> { order(the_best: :desc, created_at: :asc) }
  scope :the_best, -> { where(the_best: true) }

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :body, presence: true
  validate :one_the_best_in_question

  def mark_as_the_best
    transaction do
      question.answers.the_best.update!(the_best: false)
      update!(the_best: true)
    end
  end

  private

  def one_the_best_in_question
    errors.add(:base, 'Question can have only one the best answer') unless question && question.answers.the_best.count <= 1
  end
end
