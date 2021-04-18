# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    can :read, :all

    can :create, [Question, Answer, Comment]

    can :update, [Question, Answer, Comment], author_id: user.id

    can :mark_as_the_best, Answer, question: { author_id: user.id }

    can :destroy, [Question, Answer, Comment], author_id: user.id
    can :destroy, Link, linkable: { author_id: user.id }

    can :vote, [Question, Answer] do |model|
      model.author_id != user.id
    end

    can :create, Subscription
    can :destroy, Subscription, user_id: user.id
  end
end
