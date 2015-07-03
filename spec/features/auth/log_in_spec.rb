require 'rails_helper'

feature 'User logging in', %q{
  In order to ask questions
  user
  is able to log in
 } do

  scenario 'User tries to log in with correct credentials' do
    user = create(:user)

    sign_in_manual(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'User tries to log in with incorrect credentials' do
    user = build(:user)

    sign_in_manual(user)

    expect(page).to have_content 'Invalid email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
