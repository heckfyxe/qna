require 'rails_helper'

feature 'User can answer the question', %q{
  As authenticated user
  I'd like to be able to answer the question
} do

  scenario 'answers the question' do
    user = create(:user)
    sign_in(user)

    question = create(:question)
    visit question_path(question)

    answer_text = 'Some answer to question'
    fill_in 'Answer', with: answer_text
    click_on 'To answer'

    expect(page).to have_content answer_text
  end

  scenario 'Unauthenticated user tries to answer' do
    question = create(:question)
    visit question_path(question)

    answer_text = 'Smart answer to question'
    fill_in 'Answer', with: answer_text
    click_on 'To answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
