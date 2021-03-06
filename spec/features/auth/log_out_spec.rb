require 'rails_helper'

feature 'User can log out', %q{
  As signed in user
  I'd like to be able to log out from system
} do

  scenario 'Registered user tries to log out' do
    user = create(:user)
    sign_in(user)

    visit(root_path)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
