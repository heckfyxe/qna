class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id', dependent: :nullify
  has_many :answers, foreign_key: 'author_id', dependent: :nullify

  has_many :users_badges, dependent: :destroy
  has_many :badges, through: :users_badges

  has_many :subscriptions, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
