class Answer < ApplicationRecord
  include Linkable
  include Votable
  include HasAuthor
  include Commentable

  default_scope -> { order(the_best: :desc, created_at: :asc) }
  scope :the_best, -> { where(the_best: true) }

  belongs_to :question

  has_many_attached :files

  validates :body, presence: true
  validate :one_the_best_in_question

  def mark_as_the_best
    transaction do
      answer = question.answers.the_best.limit(1).first
      answer&.update!(the_best: false)

      author.badges << question.badge if question.badge

      update!(the_best: true)
    end
  end

  private

  def one_the_best_in_question
    errors.add(:base, 'Question can have only one the best answer') unless question && question.answers.the_best.count <= 1
  end
end
