class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers
    unless @answer
      @answer = Answer.new
      @answer.links.build
    end
  end

  def new; end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :create
    end
  end

  def update
    unless current_user.author?(question)
      flash[:alert] = "You aren't the author of the question!" unless current_user.author?(question)
      render :update and return
    end

    if question.update(question_params)
      redirect_to question
    else
      render :update
    end
  end

  def destroy
    if current_user.author?(question)
      question.destroy
      flash[:notice] = 'Question successfully deleted.'
    else
      flash[:alert] = "You aren't the author of the question!"
    end
    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : new_question
  end

  def new_question
    question = Question.new
    question.links.build
    question.build_badge
    question
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:id, :name, :url, :_destroy],
                                     badge_attributes: [:id, :title, :image])
  end

  def publish_question
    return if question.errors.any?

    message = ->(user) {
      QuestionsController.render(partial: 'questions/question', locals: { question: question, current_user: user })
    }
    QuestionsChannel.broadcast_except_user(current_user, &message)
  end
end
