require 'rails_helper'

feature 'Create answer', %q{
  In order to help someone
  user
  is able to create answer to a question
} do

  given!(:user) { create(:user, :with_questions) }
  given!(:someone_else) { create(:user, :with_questions) }

  scenario 'Authenticated user creates answer', js: true do
	  sign_in_manual(user)
    visit question_path(someone_else.questions.last)
    text = "That's simple: just be yourself!"
    fill_in 'Content', with: text
    click_on 'Create Answer'

  within '.answers' do
	  expect(page).to have_content text
  end

  end

	scenario 'User tries to create invalid answer' do
		sign_in_manual(user)
		visit question_path(user.questions.last)

		click_on 'Create Answer'
		expect(page).to have_content "Your answer could not be added due to the following errors"
	end

  scenario "Guest can't create answer" do
    visit question_path(someone_else.questions.last)

    expect(page).to_not have_field 'Content'
    expect(page).to_not have_button 'Create Answer'
  end
end