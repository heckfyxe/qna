require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated cannot edit answer' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in user
      visit questions_path

      click_on 'Edit'

      fill_in 'Title', with: 'updated title'
      fill_in 'Body', with: 'updated body'
      click_on 'Update'

      expect(page).to have_content 'updated title'
      expect(page).to have_content 'updated body'
    end

    scenario 'edits his answer with errors' do
      sign_in user
      visit questions_path

      click_on 'Edit'

      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      user = create(:user)
      sign_in user
      visit questions_path

      expect(page).to_not have_content 'Edit'
    end
  end
end
