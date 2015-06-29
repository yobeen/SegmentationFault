class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:destroy]
  before_action :set_question

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if !@answer.save
      flash[:error] = "Could not create answer"
    end
    redirect_to @question
  end
  
  def destroy
    if current_user.id == @answer.user.id
      @answer.destroy
      redirect_to @answer.question
    else
      redirect_to @question
    end
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
