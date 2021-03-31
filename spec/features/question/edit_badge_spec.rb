require 'rails_helper'

feature 'User can edit badge to question', %q{
  In order to give badge for the best answer
  As an question's author
  I'd like to be able to edit badge to question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:badge) { create(:badge, question: question) }

  background { sign_in(user) }

  scenario 'User can edit badge' do
    visit questions_path
    click_on 'Edit'

    fill_in 'Badge title', with: 'Badge for the best answer'
    attach_file 'Badge image', "#{Rails.root}/spec/assets/badge.png"

    click_on 'Update'

    expect(page).to have_content 'Badge for the best answer'
  end
end


