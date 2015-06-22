class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  
  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end
  
  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question
    else 
      render :new
    end
  end
  
  def update
    #debugger
    @question.update(question_params)
    #debugger
    redirect_to @question
  end
  
  def destroy
    
  end
  
  private
   
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
