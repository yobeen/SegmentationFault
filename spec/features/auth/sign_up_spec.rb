require 'rails_helper'

feature 'Sign up process', %q{
  In order to become a user
  guest
  is able to sign up
} do

  scenario 'Guest signs up' do
    user = build(:user)

    visit root_path

    click_on 'Sign Up'
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content "Welcome! You have signed up successfully."
  end
end