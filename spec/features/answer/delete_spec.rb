require 'rails_helper'

feature 'User can delete the answer', %q{
  As author of the answer
  I'd like to be able to delete the answer
} do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'Author deletes the answer', js: true do
      answer.author = user
      answer.save!

      visit question_path(question)
      click_on 'Delete'

      expect(page).to_not have_content answer.body
    end

    scenario 'Not author tries to delete the answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
