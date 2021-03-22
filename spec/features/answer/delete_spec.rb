require 'rails_helper'

feature 'User can delete the answer', %q{
  As author of the answer
  I'd like to be able to delete the answer
} do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, :with_attachment, author: user, question: question) }

  describe 'Author', js: true do
    background { sign_in(user) }

    scenario 'deletes the answer' do
      visit question_path(question)
      find("a[href='#{answer_path(answer)}']").click

      expect(page).to_not have_content answer.body
    end

    scenario 'deletes the attachments' do
      visit question_path(question)
      within '.attachments' do
        click_on 'Delete'
      end

      expect(page).to_not have_content answer.files.first.filename.to_s
    end
  end

  describe 'No author' do
    let(:no_author) { create(:user) }
    background { sign_in(no_author) }

    scenario 'Not author tries to delete the answer' do
      visit question_path(question)
      expect(page).to_not have_content 'Delete'
    end

    scenario 'tries to delete the attachments' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
