module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote_up(user)
    return if user.author?(self)

    vote = votes.find_by(user: user)
    if vote
      vote.update(value: vote.value + 1)
    else
      votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    return if user.author?(self)

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
    vote_val = votes.find_by(user: user)&.value
    vote_val ? vote_val : 0
  end
end
