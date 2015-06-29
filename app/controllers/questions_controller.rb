class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "Question created successfully"
      redirect_to @question
    else 
      render :new
    end
  end

  def destroy
    if current_user.id == @question.user.id
      @question.destroy
      flash[:success] = "Question deleted successfully"
    end
    redirect_to questions_path
  end
  
  private
   
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
