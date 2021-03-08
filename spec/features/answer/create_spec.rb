require 'rails_helper'

feature 'User can answer the question', %q{
  As authenticated user
  I'd like to be able to answer the question
} do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario 'answers the question' do
    sign_in(user)

    visit question_path(question)

    answer_text = 'Some answer to question'
    fill_in 'Answer', with: answer_text
    click_on 'To answer'

    expect(page).to have_content answer_text
  end

  scenario 'Unauthenticated user tries to answer' do
    visit question_path(question)

    answer_text = 'Smart answer to question'
    fill_in 'Answer', with: answer_text
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
