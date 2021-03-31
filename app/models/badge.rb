class Badge < ApplicationRecord
  belongs_to :question

  has_many :users_badges, dependent: :destroy
  has_many :users, through: :users_badges

  has_one_attached :image

  validates :title, :image, presence: true
  validates :image, content_type: %w[image/jpeg image/png]
end
