require 'rails_helper'

feature 'User can answer the question', %q{
  As authenticated user
  I'd like to be able to answer the question
} do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  context 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question with valid params' do
      answer_text = 'Some answer to question'
      fill_in 'Answer', with: answer_text
      click_on 'To answer'

      expect(page).to have_content answer_text
    end

    scenario 'answers the question with invalid params' do
      click_on 'To answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question with attached files' do
      fill_in 'Answer', with: 'Answer text'
      attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]

      click_on 'To answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiply sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      answer_text = 'Some answer to question'

      Capybara.using_session('user') do
        fill_in 'Answer', with: answer_text
        click_on 'To answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content answer_text
      end
    end
  end

  scenario 'Unauthenticated user tries to answer' do
    visit question_path(question)

    expect(page).to_not have_content 'To answer'
  end
end
