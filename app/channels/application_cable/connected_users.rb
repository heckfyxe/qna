module ApplicationCable
  class ConnectedUsers
    class << self
      def add(user)
        users[user] = 0 unless users.has_key?(user)
        users[user] += 1
      end

      def remove(user)
        return unless users.has_key?(user)

        users[user] -= 1
        users.delete(user) if users[user].zero?
      end

      def except(user)
        users.except(user).keys
      end

      def users
        @hash ||= Hash.new
      end
    end
  end
end