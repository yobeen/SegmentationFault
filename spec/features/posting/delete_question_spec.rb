require 'rails_helper'

feature 'Deleting question', %q{
  by his wish
  user
  is able to delete his question
} do

	background do
		@user = create(:user)
		@user.questions.create(attributes_for(:question))

		@someone_else = create(:user)
		@someone_else.questions.create(attributes_for(:question))
		sign_in_manual(@user)
	end

	scenario 'User deletes his own question' do
		visit question_path(@user.questions.last)
		click_on 'Delete this question'

		expect(current_path).to eq questions_path
		expect(page).to have_content "Question deleted successfully"
	end

	scenario "User can't delete someone else's question" do
		visit question_path(@someone_else.questions.last)

		expect(page).to_not have_link 'Delete question'
	end

	scenario "Guest can't delete question" do
		visit root_path
		click_on 'Sign Out'
		visit question_path(@user.questions.last)

		expect(page).to_not have_link 'Delete question'
	end
end