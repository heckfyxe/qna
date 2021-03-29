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

  def mark_as_the_best
    if current_user.author?(question)
      answer.mark_as_the_best
    else
      flash[:alert] = "You aren't the author of the question!"
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
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :question
  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
