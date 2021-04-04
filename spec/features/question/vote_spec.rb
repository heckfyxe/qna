require 'rails_helper'

feature 'User can vote for question', %q{
  In order to mark question as useful
  As an authenticated user
  I'd like to be able to vote for other users' questions
} do
  given(:question) { create(:question) }

  context 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'vote up question' do
      click_on 'Vote up'

      expect(page).to have_content 'Rating: 1'
      expect(page).to_not have_content 'Vote up'
    end

    scenario 'vote down question' do
      click_on 'Vote down'

      expect(page).to have_content 'Rating: -1'
      expect(page).to_not have_content 'Vote down'
    end

    scenario 'vote up downed question' do
      click_on 'Vote down'
      click_on 'Vote up'

      expect(page).to have_content 'Rating: 0'
    end

    scenario 'vote down upped question' do
      click_on 'Vote up'
      click_on 'Vote down'

      expect(page).to have_content 'Rating: 0'
    end
  end

  scenario 'No authenticated user cannot vote' do
    visit question_path(question)

    expect(page).to_not have_content 'Vote up'
    expect(page).to_not have_content 'Vote down'
  end
end
