class AnswersController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_answer, only: :create

  before_action :answer, only: %i[show edit update destroy mark_as_the_best]
  authorize_resource

  def create
    @answer = question.answers.build(answer_params)
    @answer.author = current_user

    respond_to do |format|
      if @answer.save
        format.json { render inline: @answer.to_json }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    answer.update(answer_params)
  end

  def mark_as_the_best
    answer.mark_as_the_best
  end

  def destroy
    answer.destroy
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
    return if answer.errors.any?

    self.class.renderer.instance_variable_set(
      :@env, {
      "HTTP_HOST" => "localhost:3000",
      "HTTPS" => "off",
      "REQUEST_METHOD" => "GET",
      "SCRIPT_NAME" => "",
      "warden" => warden
    })

    message = ->(user) { AnswersController.render(
      partial: 'answers/answer',
      locals: {
        question: answer.question,
        answer: answer,
        current_user: user }
    ) }
    AnswersChannel.broadcast_except_user(current_user, { question_id: question.id }, &message)
  end
end
