require 'rails_helper'

feature 'Voting for question', %q{
  In order to rate the quality of question
  user
  is able to vote for question
} do

  given(:user) { create(:user) }
	given(:someone_else) { create(:user, :with_questions) }
	given(:question) { someone_else.questions.first }

  background do
    sign_in_manual(user)
  end

  scenario 'user upvotes question', js: true do
    visit question_path(question)
    click_on 'Upvote'

    within ('.rating') do
      expect(page).to have_content '1'
    end
  end

  scenario 'user downvotes question', js: true do
    visit question_path(question)
    click_on 'Downvote'

    within ('.rating') do
      expect(page).to have_content '-1'
    end
  end

  scenario 'user can not vote more than once', js: true do
    visit question_path(question)
    click_on 'Downvote'

    expect(page).to_not have_link('Upvote')
    expect(page).to_not have_link('Downvote')
  end

  scenario 'user can not vote for his question', js: true do
    question.update(user: user)
    visit question_path(question)

    expect(page).to_not have_link('Upvote')
    expect(page).to_not have_link('Downvote')
  end

  scenario 'user unvotes', js: true do
    visit question_path(question)
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
