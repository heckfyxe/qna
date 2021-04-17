class NotifySubscribersMailer < ApplicationMailer
  def notification(user, question)
    @question = question
    mail to: user.email
  end
end
