require 'rails_helper'

feature 'User can add badge to question', %q{
  In order to give badge for the best answer
  As an question's author
  I'd like to be able to add badge to question
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds link when asks question', js: true do
    fill_in 'Badge title', with: 'Badge for the best answer'
    attach_file 'Badge image', "#{Rails.root}/spec/assets/badge.png"

    click_on 'Ask'

    expect(page).to have_content 'Badge for the best answer'
  end
end
