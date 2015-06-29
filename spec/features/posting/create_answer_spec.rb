require 'rails_helper'

feature 'Create amswer', %q{
  In order to help someone
  user
  is able to create answer to a question
} do

	given(:user) { create(:user) }
	given(:someone_else) {create(:user)}

	background do
		@user = create(:user, :with_questions)
		@someone_else = create(:user)
		@someone_else.questions.create(attributes_for(:question, :with_answers))
	end

	scenario 'Authenticated user creates answer' do
		sign_in_manual(@user)

		visit question_path(@someone_else.questions.last)
		text = "That's simple: just be yourself!"
		fill_in 'Content', with: text
		click_on 'Create Answer'

		expect(page).to have_content text
	end

	scenario "Guest can't create answer" do
		visit question_path(@someone_else.questions.last)

		expect(page).to_not have_field 'Content'
		expect(page).to_not have_button 'Create Answer'
	end
end