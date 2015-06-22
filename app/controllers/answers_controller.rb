class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:index, :show, :new, :create, :update, :destroy]

  def index
    @answers = @question.answers
  end

  def show
  end

  def new
    @answer = @question.answers.build
  end

  def edit
  end
  
  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to [@answer.question, @answer]
    else 
      render :new
    end
  end
  
  def update
    if @answer.update(answer_params)
      redirect_to [@answer.question, @answer]  
    else
      render :edit
    end
    
  end
  
  def destroy
    @answer.destroy
    redirect_to @question
  end
  
  private
   
  def set_answer
    @answer = Answer.find(params[:id])
  end
  
  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end