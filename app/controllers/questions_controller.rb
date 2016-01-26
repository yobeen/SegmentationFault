class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :set_question, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :unvote]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    if current_user.id == @question.user_id
      @question.destroy
      flash[:success] = "Question deleted successfully"
    end
    redirect_to questions_path
  end

  def update
    if @question.user_id == current_user.id
      @question.update(question_params)
    end
  end

  def upvote
    if current_user != @question.user
      @question.upvote_by current_user
    end
    respond_to do |format|
      format.json { render 'vote' }
    end
  end

  def downvote
    if current_user != @question.user
      @question.downvote_by current_user
    end
    respond_to do |format|
      format.json { render 'vote' }
    end
  end

  def unvote
    if current_user != @question.user
      @question.unvote_by current_user
    end
    respond_to do |format|
      format.json { render 'vote' }
    end
  end

  private
   
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :content, attachments_attributes: [:id, :file, :_destroy])
  end
end
