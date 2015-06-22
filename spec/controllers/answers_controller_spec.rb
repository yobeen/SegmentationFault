require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  
  describe "GET #index" do
    let(:my_answers) { create_list(:answer, 2, question: question) }
    
    before { get :index, question_id: question }
    
    it 'populates answers array' do
      expect(assigns(:answers)).to match_array(my_answers)
    end
   
    it 'renders index view' do 
      expect(response).to render_template :index
    end
  end
  
  describe "GET #show" do
    let(:my_answer) { create(:answer, question: question ) }
    
    before { get :show, id: my_answer, question_id: question }
    
    it 'assigns @answer variable' do
      expect(assigns(:answer)).to eq my_answer
    end
    
    it 'renders show view' do 
      expect(response).to render_template :show
    end
  end
  
  describe "GET #new" do
    before { get :new, question_id: question }
    
    it 'assigns new @answer' do
      expect(assigns(:answer)).to be_a_new(Answer) 
    end
    
    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end
  
  describe "GET #edit" do
    let(:my_answer) { create(:answer, question: question ) }
    
    before { get :edit, id: my_answer, question_id: question }
    
    it 'assigns @answer variable' do
      expect(assigns(:answer)).to eq my_answer
    end
    
    it 'renders edit view' do 
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context 'answer with valid attributes' do
      it 'saves answer to database' do
        expect { post :create, answer: attributes_for(:answer), 
                               question_id: question }.to change(question.answers, :count).by(1)
      end
      
      it 'redirects to the answer just created' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to [assigns(:answer).question, assigns(:answer)]
      end
      
    end 
    
    context 'answer with invalid attributes' do
      it 'does not save answer to database' do
        expect { post :create, answer: attributes_for(:invalid_answer), 
                               question_id: question }.to_not change(question.answers, :count)
      end
      
      it 'renders new answer form' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context 'answer with valid attributes' do
      let(:my_answer) { create(:answer, question: question ) }
      let!(:new_attributes) {attributes_for(:answer)}
      
      before { patch :update, id: my_answer, question_id: question, answer: new_attributes }
      
      it 'assigns @question variable' do
        expect(assigns(:answer)).to eq my_answer
      end
      
      it 'saves updated answer attributes' do
        my_answer.reload
        expect(new_attributes.size).to eq 1
        expect(my_answer.content).to eq new_attributes[:content]
      end
      
      it 'redirects to updated question' do
        expect(response).to redirect_to [my_answer.question, my_answer]
      end
    end
    
    context 'question with invalid attributes' do
      let(:old_attributes) { attributes_for(:answer) }
      #TODO - replace with proper my_anwer creation
      let(:my_answer) { create(:answer, content: old_attributes[:content], question: question) }
      let!(:bad_attributes) {attributes_for(:invalid_answer)}
      
      before { patch :update, id: my_answer, question_id: question, answer: bad_attributes }

      it 'does not update answer attributes' do
        my_answer.reload
        expect(old_attributes.size).to eq 1
        expect(my_answer.content).to eq old_attributes[:content]
      end
      
      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:my_answer) { create(:answer, question: question) }
    before { my_answer }
    
    it 'deletes answer' do
      expect { delete :destroy, id: my_answer, question_id: question }.to change(question.answers, :count).by(-1)
    end
    
    it 'redirects to question' do
      delete :destroy, id: my_answer, question_id: question
      expect(response).to redirect_to question
    end
  end
end
