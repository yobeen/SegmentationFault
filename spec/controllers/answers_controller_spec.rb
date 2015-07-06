require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { sign_in(user) }

  describe "POST #create" do
    context 'answer with valid attributes' do
      it 'saves answer to database' do
        expect { post :create, answer: attributes_for(:answer), 
                               question_id: question }.to change(question.answers, :count).by(1)
      end

      it 'assigns answer to current user' do
        expect{ post :create, answer: attributes_for(:answer),
                     question_id: question }.to change(user.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(question)
      end
      
    end 
    
    context 'answer with invalid attributes' do
      it 'does not save answer to database' do
        expect { post :create, answer: attributes_for(:invalid_answer), 
                               question_id: question }.to_not change(question.answers, :count)
      end

    end

    context 'when user is not logged in' do
      before { sign_out(user) }

      it 'does not save answer in db' do
        expect{ post :create, answer: attributes_for(:answer),
                     question_id: question }.to_not change(Answer, :count)
      end

      it 'redirects to sign in page' do
        post :create, answer: attributes_for(:answer),
             question_id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(attributes_for(:answer)) }

    context 'answer belongs to current user' do
      before { answer.update_attributes(user: user) }

      it 'deletes answer' do
        expect{ delete :destroy, id: answer, question_id: question }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'answer belongs to someone else' do
      let(:someone_else) { create(:user) }
      before { answer.update_attributes(user: someone_else) }

      it 'does not delete answer' do
        expect{ delete :destroy, id: answer, question_id: question }.to_not change(question.answers, :count)
      end

      it 'redirects to question' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to question
      end
    end

    context 'when user is not logged in' do
      before do
        answer.update_attributes(user: user)
        sign_out user
      end

      it 'does not delete answer' do
        expect{ delete :destroy, id: answer, question_id: question }.to_not change(question.answers, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
