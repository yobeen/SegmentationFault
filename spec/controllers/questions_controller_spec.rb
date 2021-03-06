require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "GET #index" do
    let(:my_questions) { create_list(:question, 2) }
    
    before { get :index }
    
    it 'populates questions array' do
      expect(assigns(:questions)).to match_array(my_questions)
    end
   
    it 'renders index view' do 
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    let(:my_question) { create(:question) }
    
    before { get :show, id: my_question }
    
    it 'assigns @question variable' do
      expect(assigns(:question)).to eq my_question
    end
    
    it 'renders show view' do 
      expect(response).to render_template :show
    end

    it 'assigns new answer attachment' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe "GET #new" do
    let(:user) { create(:user) }
    before do
      sign_in(user)
      get :new
    end
    
    it 'assigns new @question' do
      expect(assigns(:question)).to be_a_new(Question) 
    end
    
    it 'renders new view' do 
      expect(response).to render_template :new
    end

    it 'assigns new attachment' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    context 'user not logged in' do
      it 'redirects to signin page' do
        sign_out user
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    before { sign_in(user) }

    context 'question with valid attributes' do
      it 'saves question to database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      
      it 'redirects to the question just created' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
      end

      it 'flash success message' do
        post :create, question: attributes_for(:question)
        expect(flash[:success]).to_not be_nil
      end
      
    end 
    
    context 'question with invalid attributes' do
      it 'does not save question to database' do
        expect { post :create, question: attributes_for(:invalid_question)  }.to_not change(Question, :count)
      end
      
      it 'renders new question form' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end

    context 'when user is not logged in' do
      before { sign_out(user) }

      it 'does not save question in db' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:user) { create(:user, :with_questions) }
    let!(:someone_else) { create(:user, :with_questions) }
    before do
      sign_in(user)
    end

    context 'when user is author' do
      it 'deletes question' do
        expect{ delete :destroy, id: user.questions.last.id }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions index' do
        delete :destroy, id: user.questions.last.id
        expect(response).to redirect_to questions_path
      end

      it 'flash success message' do
        delete :destroy, id: user.questions.last.id
        expect(flash[:success]).to_not be_nil
      end
    end

    context 'when someone else is author' do
      it 'does not delete question' do
        expect{ delete :destroy, id: someone_else.questions.last.id }.to_not change(Question, :count)
      end

      it 'redirects to root questions index' do
        delete :destroy, id: someone_else.questions.last.id
        expect(response).to redirect_to questions_path
      end
    end

    context 'when user is not logged in' do
      before { sign_out(user) }

      it 'does not delete question' do
        expect{ delete :destroy, id: user.questions.last.id }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, id: user.questions.last.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

	describe 'PATCH #update' do
		let(:user) { create(:user, :with_questions) }
		let(:question) { user.questions.last }
		let(:someone_else) { create(:user) }

		before do
			sign_in(user)
		end

		context 'when current user is author' do
			before do
				patch :update, id: question.id, question: { title: "new title", content: "new content" }, format: :js
			end

			it 'saves question attributes' do
				question.reload

				expect(question.title).to eq "new title"
				expect(question.content).to eq "new content"
			end

			it 'renders update template' do
				expect(response).to render_template :update
			end
		end

		context 'when someone else is author' do
			before do
				question.update(user: someone_else)
				patch :update, id: question.id, question: { title: "new title", content: "new content" }, format: :js
			end

			it 'does not save attributes' do
				question.reload

				expect(question.title).to_not eq "new title"
				expect(question.content).to_not eq "new content"
			end
		end
  end

  describe 'PATCH #upvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:upvote) { patch :upvote, id: question.id, format: :json }

    before do
      sign_in user
    end

    it 'increases rating' do
      expect{upvote}.to change{question.rating}.by 1
    end

    it 'renders vote template' do
      upvote
      expect(response).to render_template :vote
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not change rating' do
        expect{upvote}.to_not change{question.rating}
      end
    end
  end

  describe 'PATCH #downvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:downvote) { patch :downvote, id: question.id, format: :json }

    before do
      sign_in user
    end

    it 'decreases rating' do
      expect{downvote}.to change{question.rating}.by -1
    end

    it 'renders vote template' do
      downvote
      expect(response).to render_template :vote
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not change rating' do
        expect{downvote}.to_not change{question.rating}
      end
    end
  end

  describe 'PATCH #unvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:unvote) { patch :unvote, id: question.id, format: :json }

    before do
      sign_in user
      question.upvote_by user
    end

    it 'undoes users vote' do
      unvote
      expect(user.voted_for? question).to be_falsey
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not change vote status' do
        unvote
        expect(user.voted_for? question).to be_truthy
      end
    end
  end
end
