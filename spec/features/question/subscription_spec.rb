require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to get news
  As an subscribed user
  I'd like to be able to get mails about new answers
} do
  given(:question) { create(:question) }

  context 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Subscribe'
    end

    scenario 'subscribes to question' do
      expect(page).to have_content 'Unsubscribe'
    end

    scenario 'unsubscribes from question' do
      click_on 'Unsubscribe'
      expect(page).to have_content 'Subscribe'
    end
  end

  scenario 'cannot to subscribe' do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
  end
end
