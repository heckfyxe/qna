class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to question_path(question)
    else
      redirect_to question_path(question), flash: { error: @answer.errors.full_messages.join(', ') }
    end
  end

  def update
    if current_user.author?(answer)
      answer.update(answer_params)
    else
      flash[:alert] = "You aren't the author of the answer!"
    end

    redirect_to question_path(question)
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:alert] = "You aren't the author of the answer!"
    end
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
