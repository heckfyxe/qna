class Answer < Linkable
  default_scope -> { order(the_best: :desc, created_at: :asc) }
  scope :the_best, -> { where(the_best: true) }

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many_attached :files

  validates :body, presence: true
  validate :one_the_best_in_question

  def mark_as_the_best
    transaction do
      answer = question.answers.the_best.limit(1).first
      answer&.the_best = false
      answer&.save!

      author.badges << question.badge if question.badge

      self.the_best = true
      save!
    end
  end

  private

  def one_the_best_in_question
    errors.add(:base, 'Question can have only one the best answer') unless question && question.answers.the_best.count <= 1
  end
end
