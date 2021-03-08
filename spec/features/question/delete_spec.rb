require 'rails_helper'

feature 'User can delete the question', %q{
  As author of the question
  I'd like to be able to delete the question
} do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'Author deletes the question' do
      question.author = user
      question.save!

      visit questions_path
      click_on 'Delete'

      expect(page).to have_content('Question successfully deleted.')
    end

    scenario 'Not author tries to delete the question' do
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content "You aren't the author of the question!"
    end
  end

  scenario 'Unauthenticated user tries to question' do
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
