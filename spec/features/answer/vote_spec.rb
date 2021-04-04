require 'rails_helper'

feature 'User can vote for answer', %q{
  In order to mark answer as useful
  As an authenticated user
  I'd like to be able to vote for other users' answers
} do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'vote up answer' do
      within '.answers' do
        click_on 'Vote up'

        expect(page).to have_content 'Rating: 1'
        expect(page).to_not have_content 'Vote up'
      end
    end

    scenario 'vote down answer' do
      within '.answers' do
        click_on 'Vote down'

        expect(page).to have_content 'Rating: -1'
        expect(page).to_not have_content 'Vote down'
      end
    end

    scenario 'vote up downed answer' do
      within '.answers' do
        click_on 'Vote down'
        click_on 'Vote up'

        expect(page).to have_content 'Rating: 0'
      end
    end

    scenario 'vote down upped answer' do
      within '.answers' do
        click_on 'Vote up'
        click_on 'Vote down'

        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario 'No authenticated user cannot vote' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Vote up'
      expect(page).to_not have_content 'Vote down'
    end
  end
end

