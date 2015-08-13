require 'rails_helper'

feature 'Delete files from answer', %q{
  by his wish
  user
  can delete files from his answer
} do

  given!(:user) { create(:user, :with_questions) }
  given(:question) { user.questions.last}

  scenario 'User deletes file', js: true do
    sign_in_manual(user)
    visit question_path(question)

    fill_in 'Content', with: 'Answer 111111111111'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create Answer'

    within '.answers' do
      click_on 'Edit answer'
      click_on 'Remove this file'
      click_on 'Save'

      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end