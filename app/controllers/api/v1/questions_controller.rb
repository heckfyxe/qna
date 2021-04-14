class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question, serializer: DetailedQuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.build(question_params)
    @question.save!
    render json: @question, serializer: DetailedQuestionSerializer, status: :created
  end

  def update
    question.update!(question_params)
    render json: question
  end

  def destroy
    question.destroy!
    head :ok
  end

  private

  def question
    @question ||= Question.find(params[:id])
  end

  def question_params
    question_params = params.permit(:title, :body, links: [:name, :url])
    question_params[:links_attributes] = question_params.delete :links if question_params.has_key?(:links)
    question_params.permit!
  end
end