require 'rails_helper'

feature 'Create amswer', %q{
  In order to help someone
  user
  is able to create answer to a question
} do

  given!(:user) { create(:user, :with_questions) }
  given!(:someone_else) { create(:user, :with_questions) }

  scenario 'Authenticated user creates answer', js: true do
    #set_speed(:slow)
	  sign_in_manual(user)
    visit question_path(someone_else.questions.last)
    text = "That's simple: just be yourself!"
    fill_in 'Content', with: text
    click_on 'Create Answer'

  within '.answers' do
	  expect(page).to have_content text
  end

  end

  scenario "Guest can't create answer" do
    visit question_path(someone_else.questions.last)

    expect(page).to_not have_field 'Content'
    expect(page).to_not have_button 'Create Answer'
  end
end