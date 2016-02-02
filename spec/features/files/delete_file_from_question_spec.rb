require 'rails_helper'

feature 'Delete files from question', %q{
  by his wish
  user
  can delete files from his question
} do

  given(:user) { create(:user, :with_questions) }

  background do
    sign_in_manual(user)
  end

  scenario 'User deletes file', js: true do
    visit root_path

    click_on 'New Question'
    fill_in 'Title', with: 'I have a question'
    fill_in 'Your question:', with: 'Give me some answers'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Create Question'
    expect(page).to have_link 'rails_helper.rb'

    click_on 'Edit question'
    within '.edit_question' do
      click_on 'Remove this file'
      click_on 'Save changes'
    end

    expect(page).to_not have_link 'rails_helper.rb'
  end
end