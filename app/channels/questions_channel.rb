class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from QuestionsChannel.stream_name(current_user)
  end

  def unsubscribed
    stop_all_streams
  end

  def self.broadcast_to_user(user, &message)
    ActionCable.server.broadcast stream_name(user), message.call(user)
  end

  def self.broadcast_except_user(user, &message)
    ApplicationCable::ConnectedUsers.except(user).each do |user|
      ActionCable.server.broadcast stream_name(user), message.call(user)
    end
  end

  def self.stream_name(user)
    "questions_for_user_#{user&.id}"
  end
end
