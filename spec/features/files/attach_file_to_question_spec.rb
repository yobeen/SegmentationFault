require 'rails_helper'

feature 'Attach files to question', %q{
  In order to give more information on the problem
  user
  is able to attach files to his question
} do

  given(:user) { create(:user, :with_questions) }

  background do
    sign_in_manual(user)
  end

  scenario 'User attaches files pn creation', js: true do
    visit root_path

    click_on 'New Question'
    fill_in 'Title', with: 'I have a question'
    fill_in 'Content', with: 'Give me some answers'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"

    click_link 'Attach another file'
    within '.nested-fields:not(:first-child)' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Create Question'
    expect(page).to have_link 'rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb'
  end
end