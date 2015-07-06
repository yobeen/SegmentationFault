require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :content }
  
  it { should validate_length_of(:content).is_at_most(15000) } 

  it { should belong_to(:question) }
  
  it { have_db_index(:created_at) }

  it { should belong_to(:user) }
end
