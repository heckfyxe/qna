module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    vote = votes.find_by(user: user)
    if vote
      vote.update(value: vote.value + 1)
    else
      votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    vote = votes.find_by(user: user)
    if vote
      vote.update(value: vote.value - 1)
    else
      votes.create(user: user, value: -1)
    end
  end

  def rating
    votes.sum(:value)
  end

  def user_vote(user)
    votes.find_by(user: user)&.value || 0
  end
end
