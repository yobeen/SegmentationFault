require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(50) }

  it { should have_many(:questions).order(created_at: :desc).dependent(:destroy) }
end