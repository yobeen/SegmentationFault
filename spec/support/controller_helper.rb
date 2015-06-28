module ControllerHelpers
	def sign_in_user(user)
		@request.env["devise.mapping"] = Devise.mappings[:user]
		sign_in user
	end

	def sign_in_manual(user)
		visit root_path
		click_on 'Sign In'
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		click_button 'Log in'
	end
end