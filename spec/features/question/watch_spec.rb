require 'rails_helper'

feature 'User can watch questions and answers', %q{
  As unauthenticated user
  I'd like to be able watch questions and answers
} do

  scenario 'Unauthenticated user looks at questions' do
    questions = create_list(:question, 3)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user can watch questions and answers' do
    answer = create(:answer)
    visit question_path(answer.question)

    expect(page).to have_content answer.question.title
    expect(page).to have_content answer.body
  end
end
