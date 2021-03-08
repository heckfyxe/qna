class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def create
    @answer = question.answers.build(answer_params)
    @answer.save
    redirect_to question_path(question)
  end

  def update
    answer.update(answer_params)
    redirect_to question_path(question)
  end

  def destroy
    answer.destroy
    redirect_to question_path(question)
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
