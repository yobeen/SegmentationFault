require 'rails_helper'

feature 'User logging out', %q{
	In order to end session
	user
	is able to log ot
 } do

  scenario 'User logs out' do
    user = create(:user)

		sign_in_manual(user)

		click_on 'Sign Out'

		expect(current_path).to eq root_path
		expect(page).to have_content 'Signed out successfully.'
	end
end
