require 'rails_helper'

feature 'Creating question', %q{
  In order to get help
  user
  is able to create a question
} do

	given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
		sign_in_manual(user)

		visit root_path
		click_on 'New Question'
		fill_in 'Title', with: 'I have a question'
		fill_in 'Content', with: 'Give me some answers'
		click_on 'Create Question'

		expect(page).to have_content "Question created successfully"
		expect(current_path).to eq(question_path(Question.last))
	end

	scenario 'Guest creates a question' do

		visit root_path
		click_on 'New Question'

		expect(current_path).to eq new_user_session_path
	end
end