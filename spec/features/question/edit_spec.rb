require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated cannot edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Author', js: true do
    background do
      sign_in user
      visit questions_path
      click_on 'Edit'
    end

    scenario 'edits his question' do
      fill_in 'Title', with: 'updated title'
      fill_in 'Body', with: 'updated body'
      click_on 'Update'

      expect(page).to have_content 'updated title'
      expect(page).to have_content 'updated body'
    end

    scenario 'edits his question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'Update'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his question and attach files' do
      fill_in 'Title', with: 'updated title'
      fill_in 'Body', with: 'updated body'
      attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on 'Update'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'No author' do
    let!(:no_author) { create(:user) }

    background do
      sign_in no_author
      visit questions_path
    end

    scenario "tries to edit other user's question" do
      expect(page).to_not have_content 'Edit'
    end
  end
end
