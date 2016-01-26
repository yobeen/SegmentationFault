require 'rails_helper'

feature 'Attach files to answer', %q{
  In order to give more information with his answer
  user
  is able to attach files to his answer
} do
  given(:user) { create(:user, :with_questions) }

  background do
    sign_in_manual(user)
  end

  scenario 'User attaches files to his answer', js: true do
    visit question_path(user.questions.last)
    text = "That's simple: just be yourself!"
    fill_in 'Content', with: text
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

   click_link 'Attach another file'
   within '.new_answer .nested-fields:not(:first-child)' do
     attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
   end

    click_on 'Create Answer'

    within('.answers') do
      expect(page).to have_content text
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end