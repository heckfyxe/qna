class QuestionsChannel < ApplicationCable::Channel
  def self.stream_name(user)
    "questions_for_user_#{user&.id}"
  end
end
