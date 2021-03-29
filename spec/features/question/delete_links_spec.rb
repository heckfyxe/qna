require 'rails_helper'

feature 'User can delete links from question', %q{
  As an question's author
  I'd like to be able to delete links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  context 'Author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'deletes link from his question', js: true do
      within '.links' do
        click_on 'Delete'
      end

      expect(page).to_not have_content link.name
    end
  end

  scenario 'No author cannot to delete question' do
    visit question_path(question)

    within '.links' do
      expect(page).to_not have_content 'Delete'
    end
  end
end
