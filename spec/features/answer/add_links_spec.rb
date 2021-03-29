require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my queanswerstion
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:google_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Answer', with: 'My answer'
  end

  scenario 'User adds link when give an answer', js: true do
    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: google_url

    click_on 'To answer'

    within '.answers' do
      expect(page).to have_link 'Google', href: google_url
    end
  end

  scenario 'User adds several links when answers', js: true do
    all('.nested-fields').last.tap do |f|
      f.fill_in 'Link name', with: 'My gist'
      f.fill_in 'Url', with: gist_url
    end

    click_on 'Add link'

    all('.nested-fields').last.tap do |l|
      l.fill_in 'Link name', with: 'Google'
      l.fill_in 'Url', with: google_url
    end

    click_on 'To answer'

    expect(page).to have_content 'hosted with ❤ by GitHub'
    expect(page).to have_link 'Google', href: google_url
  end

  scenario 'User adds link to github gist', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'To answer'

    expect(page).to have_content 'hosted with ❤ by GitHub'
  end
end
