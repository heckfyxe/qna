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

    scenario 'Author deletes the answer' do
      answer.author = user
      answer.save!

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content('Answer successfully deleted.')
    end

    let(:answer) { create(:answer, question: question) }

    scenario 'Not author tries to delete the answer' do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content "You aren't the author of the answer!"
    end
  end

  scenario 'Unauthenticated user tries to answer' do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
