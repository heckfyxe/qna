module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      find_user
      ConnectedUsers.add(current_user)
    end

    def disconnect
      ConnectedUsers.remove(current_user)
    end

    private

    def find_user
      self.current_user = env["warden"].user(:user)
    end
  end
end
