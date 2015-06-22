require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  
  it { should validate_length_of(:content).is_at_most(15000) }
  it { should validate_length_of(:title).is_at_most(250) } 

  it { should have_many(:answers).order(created_at: :desc).dependent(:destroy) }

  it { should belong_to(:user).order(created_at: :desc) } 
end
