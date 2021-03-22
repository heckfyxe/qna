require 'rails_helper'

feature 'User can delete the question', %q{
  As author of the question
  I'd like to be able to delete the question
} do
  let(:user) { create(:user) }
  let!(:question) { create(:question, :with_attachment, author: user) }

  describe 'Author', js: true do
    background { sign_in(user) }

    scenario 'deletes the question' do
      visit questions_path
      click_on 'Delete'

      expect(page).to have_content 'Question successfully deleted.'
    end

    scenario 'deletes the attachments' do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to_not have_content question.files.first.filename.to_s
    end
  end

  describe 'No author' do
    let(:no_author) { create(:user) }
    background { sign_in(no_author) }

    scenario 'tries to delete the question' do
      visit questions_path

      expect(page).to_not have_content 'Delete'
    end

    scenario 'tries to delete the attachments' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
  end
end
