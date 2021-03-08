require 'rails_helper'

feature 'User can watch answers to the question', %q{
  As unauthenticated user
  I'd like to be able to watch answers to the question
} do
  let(:question) { create(:question) }
  let(:answers) { create_list(:answer, 5, question: question) }

  scenario 'Unauthenticated user watch answers in question page' do
    answers

    visit question_path(question)

    answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end