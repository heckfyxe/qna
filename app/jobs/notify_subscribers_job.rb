class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(question)
    NotifySubscribersService.new.notify(question)
  end
end
