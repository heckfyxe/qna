class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, :votable, presence: true
  validates :value, numericality: { only_integer: true }
  validates :value, inclusion: { in: -1..1 }
end
