require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
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
end
