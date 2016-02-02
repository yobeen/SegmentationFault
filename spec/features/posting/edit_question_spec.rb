require 'rails_helper'

feature 'Edit question', %q{
  In order to correct his question
  user
  is able to edit his question
} do

  let(:user) { create(:user, :with_questions) }
  let(:question) { user.questions.last }
  let(:someone_else) { create(:user) }

  scenario 'user edits his question', js: true do
    sign_in_manual(user)
    visit question_path(question)
    old_text = question.content

    expect(page).to have_link 'Edit question'
    click_link 'Edit question'
    within '.edit-question-form' do
      fill_in 'Your question:', with: 'New text 1111111'
    end
    click_on 'Save changes'

    expect(page).to have_content('New text 1111111')
    expect(page).to_not have_selector('.edit-question-form')
    expect(page).to_not have_content(old_text)
  end

  scenario 'someone else tries to edit user question' do
    sign_in_manual(someone_else)
    visit question_path(question)

    expect(page).to_not have_content('Edit question')
  end

  scenario 'guest tries to edit question' do
    visit root_path
    if page.has_link? 'Sign Out'
      click_on 'Sign Out'
    end
    visit question_path(question)

    expect(page).to_not have_content('Edit question')
  end
end