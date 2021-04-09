require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to offer an opinion to answer
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment' do
      within '.new-answer-comment' do
        fill_in 'Body', with: 'New comment'
        click_on 'Comment'
      end

      expect(page).to have_content 'New comment'
    end

    scenario 'cannot create empty comment' do
      within '.new-answer-comment' do
        fill_in 'Body', with: ''
        click_on 'Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'multiply sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer-comment' do
          fill_in 'Body', with: 'New comment'
          click_on 'Comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New comment'
      end
    end
  end

  scenario 'Guest cannot comment' do
    visit question_path(question)

    expect(page).to_not have_button 'Comment'
  end
end