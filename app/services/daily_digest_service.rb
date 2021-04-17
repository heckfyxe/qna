class DailyDigestService
  def send_digest
    time = 1.day.ago
    User.find_each do |user|
      DailyDigestMailer.digest(user, time).deliver_later
    end
  end
end