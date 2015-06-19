require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  
  it { should validate_length_of(:content).is_at_most(15000) }
  it { should validate_length_of(:title).is_at_most(250) } 

  it { should have_many(:answers).dependent(:destroy) }
  
  let!(:answer1) { FactoryGirl.create(:answer, created_at: 2.days.ago); }
  let!(:answer2) { FactoryGirl.create(:answer, created_at: 1.day.ago); }
  let!(:answer3) { FactoryGirl.create(:answer, created_at: 4.days.ago); }

  it 'answers ordered by creation date descending' do
    expect(Answer.pluck(:id)).to eq [answer2, answer1, answer3].map{ |a| a.id }
  end

end
