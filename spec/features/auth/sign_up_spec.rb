require 'rails_helper'

feature 'Sign up the new user', %q{
  As unregistered user
  I'd like to sign up to system
} do

  background { visit new_user_registration_path }

  scenario 'user sign up with valid data' do
    fill_in 'Email', with: 'valid@mail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'user sign up with invalid data' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end