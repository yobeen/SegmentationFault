require 'rails_helper'

feature 'Accept answer', %q{
  In order to mark most accurate answer
  author
  is able to choose one answer as accepted
} do

  given!(:user) { create(:user, :with_questions) }
  given!(:someone_else) { create(:user, :with_questions) }
  given(:question) { user.questions.last}
  given!(:answer) { create(:answer, question: question) }
  scenario 'User accepts answer to his question', js: true do
    sign_in_manual(user)
    visit question_path(question)

    expect(page).to_not have_selector('.accepted')

    within("#answer_#{answer.id}") do
      click_on 'Accept answer'
      expect(page).to_not have_link("Accept answer")
    end

    expect(page).to have_selector(".answers > :first-child", text: answer.content)
	end

  scenario 'Author accepts another answer', js: true do
    sign_in_manual(user)
    another_answer = question.answers.create(attributes_for(:answer))
		another_answer.update(accepted: true)
    visit question_path(question)

    expect(page).to have_selector('.accepted')
    within("#answer_#{answer.id}") do
      click_on 'Accept answer'
    end

    expect(page).to have_selector(".answers > :first-child", text: answer.content)
    expect(page).to_not have_selector("#answer_#{another_answer.id}.accepted")
  end

  scenario 'Someone else tries to accept answer to user question' do
    sign_in_manual(someone_else)

    visit question_path(question)
    expect(page).to_not have_link 'Accept this answer'
  end

  scenario 'Guest tries to accept answer' do
    visit root_path
    if page.has_link? 'Sign Out'
      click_on 'Sign Out'
    end
    visit question_path(question)

    expect(page).to_not have_link 'Accept this answer'
  end
end
