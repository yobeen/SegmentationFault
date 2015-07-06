require 'rails_helper'

feature 'Delete answer process', %q{
  by his wish
  user
  is able to delete his answer
} do

  background do
    @user = create(:user, :with_questions)
    @question = @user.questions.last
    @answer = @question.answers.create(content:"qwe asd qwe asd qwe")
    @text_to_watch = @answer.content

    @someone_else = create(:user, :with_questions)

    sign_in_manual(@user)
  end

  scenario 'User deletes his answer' do
    @answer.update_attributes(user: @user)

    visit question_path(@question)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(@question)
    expect(page).to_not have_content @text_to_watch
  end

  scenario "User can't delete someone else's answer" do
    visit question_path(@someone_else.questions.last)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    visit root_path
    click_on 'Sign Out'
    visit question_path(@question)
    expect(page).to_not have_content 'Delete answer'
  end
end