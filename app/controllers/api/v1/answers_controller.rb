class Api::V1::AnswersController < Api::V1::BaseController
  def index
    render json: question.answers
  end

  def show
    render json: answer, serializer: DetailedAnswerSerializer
  end

  def create
    @answer = question.answers.build(answer_params)
    @answer.author = current_resource_owner
    @answer.save!
    render json: @answer, serializer: DetailedAnswerSerializer, status: :created
  end

  def update
    answer.update!(answer_params)
    render json: answer
  end

  def destroy
    answer.destroy!
    head :ok
  end

  private

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    answer_params = params.permit(:body, :the_best, links: [:name, :url])
    answer_params[:links_attributes] = answer_params.delete :links if answer_params.has_key?(:links)
    answer_params.permit!
  end
end