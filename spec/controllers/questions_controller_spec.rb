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
  end

  describe "GET #new" do
    before { get :new }
    
    it 'assigns new @question' do
      expect(assigns(:question)).to be_a_new(Question) 
    end
    
    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    let(:my_question) { create(:question) }
    
    before { get :edit, id: my_question }
    
    it 'assigns @question variable' do
      expect(assigns(:question)).to eq my_question
    end
    
    it 'renders edit view' do 
      expect(response).to render_template :edit
    end
  end
  
  describe "POST #create" do
    context 'question with valid attributes' do
      it 'saves question to database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end
      
      it 'redirects to the question just created' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to assigns(:question)
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
  end
  
  describe "PATCH #update" do
    context 'question with valid attributes' do
      let(:my_question) { create(:question) }
      let!(:new_attributes) {attributes_for(:question)}
      
      before { patch :update, id: my_question, question: new_attributes }
      
      it 'assigns @question variable' do
        
        expect(assigns(:question)).to eq my_question
      end
      
      it 'saves updated question attributes' do
        my_question.reload
        expect(new_attributes.size).to eq 2
        expect(my_question.title).to eq new_attributes[:title]
        expect(my_question.content).to eq new_attributes[:content]
      end
      
     it 'redirects to updated question' do
       expect(response).to redirect_to my_question
     end
    end
    
    context 'question with invalid attributes' do
      let(:old_attributes) { attributes_for(:question) }
      let(:my_question) { create(:question, old_attributes) }
      let!(:bad_attributes) {attributes_for(:invalid_question)}
      
      before { patch :update, id: my_question, question: bad_attributes }

      it 'does not update question attributes' do
        my_question.reload
        expect(old_attributes.size).to eq 2
        expect(my_question.title).to eq old_attributes[:title]
        expect(my_question.content).to eq old_attributes[:content]
      end
      
      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:my_question) { create(:question) }
    before { my_question }
    
    it 'deletes question' do
      expect { delete :destroy, id: my_question }.to change(Question, :count).by(-1)
    end
    
    it 'redirects to index' do
      delete :destroy, id: my_question
      expect(response).to redirect_to questions_path
    end
  end
end
