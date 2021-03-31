require 'rails_helper'

feature 'User can watch his earned badged', %q{
  In order to provide info about user's achievements
  As an authenticated user
  I'd like to be able to watch my earned badges
} do

  given(:user) { create(:user) }
  given(:badge) { create(:badge) }
  given!(:users_badge) { create(:users_badge, user: user, badge: badge) }

  scenario 'Authenticated user can watch his badges' do
    sign_in(user)
    visit questions_path

    click_on 'Badges'

    expect(page).to have_content badge.title
  end

  scenario 'Unauthenticated user cannot watch badges' do
    visit questions_path

    expect(page).to_not have_content 'Badges'
  end
end
