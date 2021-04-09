class Question < ApplicationRecord
  include Linkable
  include Votable
  include HasAuthor
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :badge, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true
end
