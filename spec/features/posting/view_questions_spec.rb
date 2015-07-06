require 'rails_helper'

feature 'Checking question page', %q{
  In order to see answers
  guest
  is able to open question page
} do

  given!(:questions) { create_list(:question, 2, :with_answers) }

  scenario 'Guest views questions_list' do
    visit root_path

    expect(page).to have_content "Listing questions"
    questions.each do |question|
      expect(page).to have_link "Show", href: question_path(question)
    end
  end

  scenario 'Guest opens question page' do

    visit root_path
    find(:linkhref, question_path(questions[0])).click

    expect(current_path).to eq question_path(questions[0])
    questions[0].answers.each do |answer|
      expect(page).to have_content answer.content
    end
  end
end