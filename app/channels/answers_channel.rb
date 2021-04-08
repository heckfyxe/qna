class AnswersChannel < ApplicationCable::Channel
  def self.stream_name(user)
    "answers_for_user_#{user&.id}"
  end
end