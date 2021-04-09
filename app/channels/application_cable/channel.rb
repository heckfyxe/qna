module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def subscribed
      stream_from self.class.stream_name(current_user, params)
    end

    def unsubscribed
      stop_all_streams
    end

    def self.broadcast_to_user(user, params, &message)
      ActionCable.server.broadcast stream_name(user, params), message.call(user)
    end

    def self.broadcast_except_user(user, params, &message)
      ApplicationCable::ConnectedUsers.except(user).each do |user|
        ActionCable.server.broadcast stream_name(user, params), message.call(user)
      end
    end

    def self.stream_name(user, params = {}); end
  end
end
