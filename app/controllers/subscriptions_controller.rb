class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    return head :conflict if question.subscribed_by?(current_user)
    question.subscribe(current_user)
  end

  def destroy
    return head :conflict unless question.subscribed_by?(current_user)
    question.unsubscribe(current_user)
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end
