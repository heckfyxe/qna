class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers
    @answer ||= Answer.new
  end

  def new; end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
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
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
