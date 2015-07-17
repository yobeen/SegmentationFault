require 'rails_helper'

feature 'Edit answer', %q{
  In order to correct his answer
  user
  is able to edit answer text
} do

  given!(:user) { create(:user, :with_questions) }
  given!(:someone_else) { create(:user, :with_questions) }
  given(:question) { user.questions.last}
  given!(:answer) { create(:answer, question: question)}#, user: user) }
  scenario 'User edits his own answer', js: true do
    #debugger
    sign_in_manual(user)
    visit question_path(question)

    #save_and_open_page
    within '.answers' do
		  #TODO form already expanded
			expect(page).to have_link 'Edit answer'

	    old_text = answer.content
	    text = "That's simple: just be yourself!"
	    # click_on 'Edit answer'

      #TODO elements not found
      fill_in 'Answer', with: text

      click_on 'Save'

      expect(page).to have_content text
      expect(page).to_not have_content old_text
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Someone else tries to edit user answer' do
    sign_in_manual(someone_else)

    visit question_path(question)
    expect(page).to_not have_link 'Edit answer'
  end

  scenario 'Guest tries to edit answer' do
    visit root_path
    if page.has_link? 'Sign Out'
      click_on 'Sign Out'
    end
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end
end