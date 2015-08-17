require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user, :with_questions) }
  let(:someone_else) { create(:user) }
  before { sign_in(user) }

  describe "POST #create" do
    context 'answer with valid attributes' do
      it 'saves answer to database' do
        expect { post :create, answer: attributes_for(:answer), 
                               question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'assigns answer to current user' do
        expect{ post :create, answer: attributes_for(:answer),
                     question_id: question, format: :js }.to change(user.answers, :count).by(1)
      end

    end
    
    context 'answer with invalid attributes' do
      it 'does not save answer to database' do
        expect { post :create, answer: attributes_for(:invalid_answer), 
                               question_id: question, format: :js }.to_not change(question.answers, :count)
      end
    end

    context 'when user is not logged in' do
      before { sign_out(user) }

      it 'does not save answer in db' do
        expect{ post :create, answer: attributes_for(:answer),
                     question_id: question, format: :js }.to_not change(Answer, :count)
      end

    end
  end

  describe "PATCH #update" do
    context 'answer with valid attributes' do
      let(:my_answer) { create(:answer, question: question, user: user ) }
      let!(:new_attributes) {attributes_for(:answer)}

      before { patch :update, id: my_answer, question_id: question, answer: new_attributes, format: :js }

      it 'assigns @question variable' do
        expect(assigns(:answer)).to eq my_answer
      end

      it 'assigns @question variable' do
        expect(assigns(:question)).to eq question
      end

      it 'saves updated answer attributes' do
        my_answer.reload
        expect(new_attributes.size).to eq 1
        expect(my_answer.content).to eq new_attributes[:content]
      end

      it 'render updated answer template' do
        expect(response).to render_template :update
      end
    end
  end

  describe "PATCH #accept" do
	  let(:question) { user.questions.last }
	  let(:answers) { create_list(:answer, 3, question: question) }
	  let(:answer) { answers[0] }

	  before do
		  sign_in(user)
	  end

	  context 'question belongs to current user' do
		  before do
			  patch :accept, question_id: question.id, id: answer.id, format: :js
		  end

		  it 'assigns answer variable' do
			  expect(assigns(:answer)).to eq answer
		  end

		  it 'assigns question variable' do
			  expect(assigns(:question)).to eq question
		  end

		  it 'accepts answer' do
			  answer.reload
			  expect(answer.accepted?).to be_truthy
		  end

		  it 'renders accept template' do
			  expect(response).to render_template :accept
		  end
	  end

	  context 'question belongs to someone else' do
		  before do
			  question.update_attributes(user: someone_else)
			  patch :accept, question_id: question.id, id: answer.id, format: :js
		  end

		  it 'does not accept answer' do
			  answer.reload
			  expect(answer.accepted?).to be_falsey
		  end
	  end

	  context 'user not logged in' do
		  before do
			  sign_out(user)
			  patch :accept, question_id: question.id, id: answer.id, format: :js
		  end

		  it 'does not accept answer' do
			  answer.reload
			  expect(answer.accepted?).to be_falsey
		  end
	  end

  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(attributes_for(:answer)) }

    context 'answer belongs to current user' do
      before { answer.update_attributes(user: user) }
      it 'deletes answer' do
        expect{ delete :destroy, id: answer, question_id: question, format: :js }.to change(question.answers, :count).by(-1)
      end

    end

    context 'answer belongs to someone else' do
      let(:someone_else) { create(:user) }
      before { answer.update_attributes(user: someone_else) }

      it 'does not delete answer' do
        expect{ delete :destroy, id: answer, question_id: question, format: :js }.to_not change(question.answers, :count)
      end

    end

    context 'when user is not logged in' do
      before do
        answer.update_attributes(user: user)
        sign_out user
      end

      it 'does not delete answer' do
        expect{ delete :destroy, id: answer, question_id: question, format: :js }.to_not change(question.answers, :count)
      end

    end
  end

  describe 'PATCH #upvote' do
    let(:answer) { create(:answer, question_id: question.id) }
    let(:question) { create(:question) }
    let(:upvote) { patch :upvote, question_id: question.id, id: answer.id, format: :json }

    before do
      sign_in user
    end

    it 'increases rating' do
      expect{upvote}.to change{answer.rating}.by 1
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
        expect{upvote}.to_not change{answer.rating}
      end
    end
  end

  describe 'PATCH #downvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question_id: question.id) }
    let(:downvote) { patch :downvote, question_id: question.id, id: answer.id, format: :json }

    before do
      sign_in user
    end

    it 'decreases rating' do
      expect{downvote}.to change{answer.rating}.by -1
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
        expect{downvote}.to_not change{answer.rating}
      end
    end
  end

  describe 'PATCH #unvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question_id: question.id) }
    let(:unvote) { patch :unvote, question_id: question.id, id: answer.id, format: :json }

    before do
      sign_in user
      answer.upvote_by user
    end

    it 'undoes users vote' do
      unvote
      expect(user.voted_for? answer).to be_falsey
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not change vote status' do
        unvote
        expect(user.voted_for? answer).to be_truthy
      end
    end
  end
end
