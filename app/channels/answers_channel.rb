class AnswersChannel < ApplicationCable::Channel
  def self.stream_name(user, params)
    "answers_for_user_#{user&.id}_with_question_#{params[:question_id]}"
  end
end