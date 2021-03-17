require 'rails_helper'

feature 'User can choice the best answer to the question', %q{
  As author of the question,
  I'd like to be able to choice the best answer.
} do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }
  let!(:the_best_answer) { create(:answer, :the_best, question: question, author: user) }

  context 'Author of the question' do
    background { sign_in(user) }

    scenario 'can choose the best answer', js: true do
      visit question_path(question)

      within '.the-best-answer' do
        expect(page).to have_content the_best_answer.body
      end

      click_on 'Mark as the best answer'

      within '.the-best-answer' do
        expect(page).to have_content answer.body
      end
    end
  end

  scenario 'User can see the best answer' do
    visit question_path(question)

    within '.the-best-answer' do
      expect(page).to have_content the_best_answer.body
    end
  end

  scenario 'No author cannot choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Mark as the best answer'
  end
end
