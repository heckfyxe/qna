require 'rails_helper'

feature 'User can edit links of question', %q{
  As an question's author
  I'd like to be able to edit links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:google_url) { 'https://google.com' }

  given(:google_link) { create(:link, name: 'Google', url: google_url, linkable: question) }

  background { sign_in(user) }

  scenario 'User can add link', js: true do
    visit questions_path
    click_on 'Edit'
    click_on 'Add link'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Update'

    expect(page).to have_content 'Google'
  end

  scenario 'User can add several links', js: true do
    visit questions_path
    click_on 'Edit'
    click_on 'Add link'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'Add link'

    all('.nested-fields').last.tap do |l|
      l.fill_in 'Link name', with: 'Github gist'
      l.fill_in 'Url', with: gist_url
    end

    click_on 'Update'

    expect(page).to have_content 'Google'
    expect(page).to have_content 'hosted with ❤ by GitHub', wait: 10
  end

  scenario 'User can remove link', js: true do
    google_link
    visit questions_path
    click_on 'Edit'

    click_on 'Remove link'
    click_on 'Update'

    expect(page).to_not have_content 'Google'
  end
end

