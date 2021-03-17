class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author?(answer)
      answer.update(answer_params)
    else
      flash[:alert] = "You aren't the author of the answer!"
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
    else
      flash[:alert] = "You aren't the author of the answer!"
    end
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question
  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
