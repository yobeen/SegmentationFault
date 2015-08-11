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

	scenario 'User attaches files to his question', js: true do
		sign_in_manual(user)

		visit root_path

		click_on 'New Question'

		fill_in 'Title', with: 'I have a question'
		fill_in 'Content', with: 'Give me some answers'

		attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
		click_link 'Attach another file'

		within '.nested-fields:not(:first-child)' do
			attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
		end

		click_on 'Create question'
		expect(page).to have_link 'rails_helper.rb'
		expect(page).to have_link 'spec_helper.rb'
	end

end