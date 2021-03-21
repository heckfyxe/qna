require 'rails_helper'

feature 'User can answer the question', %q{
  As authenticated user
  I'd like to be able to answer the question
} do
  let(:question) { create(:question) }

  context 'Authenticated user', js: true do
    let(:user) { create(:user) }

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

  scenario 'Unauthenticated user tries to answer' do
    visit question_path(question)

    answer_text = 'Smart answer to question'
    fill_in 'Answer', with: answer_text
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
