class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :accept]
  before_action :set_question

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    #TODO crutch
    @answer.attachments.map do |a|
      if a.file.file == nil
        @answer.attachments.delete(a)
      end
    end

    if !@answer.save
      flash[:error] = "Could not create answer"
    end
  end

  def update
	  if current_user.id == @answer.user_id
	    @answer.update(answer_params)
	  end
  end
  
  def destroy
    if current_user.id == @answer.user_id
      @answer.destroy
    end
  end

  def accept
	  if current_user.id == @question.user_id
		  @answer.accept
	  else
		  render nothing: true
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
    params.require(:answer).permit(:content, attachments_attributes: [:id, :file, :_destroy])
  end
end
