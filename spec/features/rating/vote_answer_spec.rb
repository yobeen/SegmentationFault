require 'rails_helper'

feature 'Voting for answer', %q{
  In order to rate the quality of answer
  user
  is able to vote for question
} do

	given(:user) { create(:user) }
	given(:someone_else) { create(:user, :with_questions) }
	given(:question) { someone_else.questions.first }
	given!(:answer) { create(:answer, question: question, user: someone_else) }

  background do
    sign_in_manual(user)
  end

  scenario 'user upvotes answer', js:true do
    visit question_path(question)

    within ('.answers') do
      click_link 'Upvote'

      within ('.rating') do
        expect(page).to have_content '1'
      end
    end
  end

  scenario 'user downvotes answer', js:true do
    visit question_path(question)

    within ('.answers') do
      click_link 'Downvote'

      within ('.rating') do
        expect(page).to have_content '-1'
      end
    end
  end

  scenario 'user can not vote more than once', js:true do
    visit question_path(question)

    within ('.answers') do
      click_link 'Downvote'

      expect(page).to_not have_link('Upvote')
      expect(page).to_not have_link('Downvote')
    end
  end

  scenario 'user can not vote for his answer', js:true do
    answer.update(user: user)
    visit question_path(question)

    within ('.answers') do
      expect(page).to_not have_link('Upvote')
      expect(page).to_not have_link('Downvote')
    end
  end

  scenario 'user unvotes', js:true do
    visit question_path(question)

    within ('.answers') do
      click_link 'Upvote'

      within ('.rating') do
        expect(page).to have_content '1'
      end

      click_link 'Unvote'

      within ('.rating') do
        expect(page).to have_content '0'
      end

      expect(page).to have_link('Upvote')
      expect(page).to have_link('Downvote')
    end
  end
end