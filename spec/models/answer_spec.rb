require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :content }
  it { should validate_length_of(:content).is_at_most(15000) }
  it { should belong_to(:question) }
  it { have_db_index(:created_at) }
  it { should belong_to(:user) }

  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  describe '#accept' do
    let(:question) { create(:question, :with_answers) }
    let(:answer) { question.answers.last }

    it "sets accepted attribute to true" do
      answer.accept
      expect(answer.accepted?).to be_truthy
    end

    it "returns true" do
      expect(answer.accept).to be_truthy
    end

    context 'when question already has accepted answer' do
      it 'rejects already accepted answer' do
        accepted_alrdy = question.answers.first
        accepted_alrdy.update(accepted: true)

        answer.accept
        accepted_alrdy.reload
        expect(accepted_alrdy.accepted?).to be_falsey
      end
    end
  end
end
