class User < ApplicationRecord
  has_many :questions, foreign_key: 'author_id', dependent: :nullify
  has_many :answers, foreign_key: 'author_id', dependent: :nullify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(model)
    model.author_id == id
  end
end