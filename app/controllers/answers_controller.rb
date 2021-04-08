class AnswersController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_answer, only: :create

  def create
    @answer = question.answers.build(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
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

  helper_method :question
  helper_method :answer

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    message = ->(user) { AnswersController.render(
      partial: 'answers/answer',
      locals: {
        question: answer.question,
        answer: answer,
        current_user: user }
    ) }
    AnswersChannel.broadcast_except_user(current_user, &message)
  end
end
