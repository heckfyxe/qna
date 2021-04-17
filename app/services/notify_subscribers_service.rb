class NotifySubscribersService
  def notify(question)
    question.subscribers.find_each do |subscriber|
      NotifySubscribersMailer.notification(subscriber, question).deliver_later
    end
  end
end