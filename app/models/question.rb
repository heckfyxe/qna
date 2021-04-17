class Question < ApplicationRecord
  include Linkable
  include Votable
  include HasAuthor
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :badge, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :add_author_to_subscribers

  def subscribe(user)
    subscribers << user
  end

  def unsubscribe(user)
    subscribers.delete(user)
  end

  def subscribed_by?(user)
    subscribers.find_by(id: user.id).present?
  end

  private

  def add_author_to_subscribers
    subscribers << author
  end
end
