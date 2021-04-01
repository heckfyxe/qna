class Question < ApplicationRecord
  include Linkable

  has_many :answers, dependent: :destroy
  has_one :badge, dependent: :destroy

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many_attached :files

  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true
end
