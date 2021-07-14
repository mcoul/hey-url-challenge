# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    before do
      FactoryBot.create_list(:url, 15)
    end

    it 'shows a list of short urls' do
      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(page).to have_button('shorten_url')

      within('tbody') do
        expect(page).to have_selector('tr', count: 10)
      end
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      url = create(:url)
      click = create(:click, url_id: url.id)

      visit url_path(url.short_url)
      
      expect(page).to have_text("Stats for #{url.short_url}")
      expect(page).to have_text("Created #{url.created_at.strftime('%b %d, %Y') }")
      expect(page).to have_text("Original URL: #{url.original_url}")

      expect(page).to have_selector('#total-clicks-chart')
      expect(page).to have_selector('#browsers-chart')
      expect(page).to have_selector('#platforms-chart')

    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        
        expect(page).to have_text("The page you were looking for doesn't exist.")
        expect(page).to have_text("You may have mistyped the address or the page may have moved.")
        expect(page).to have_text("If you are the application owner check the logs for more information.")
      end
    end
  end

  describe 'create' do
    before do
      visit '/'
      fill_in 'url_textbox', with: url.original_url
      click_button 'shorten_url'
    end

    let(:url) { create(:url, original_url: "instagram.com") }

    context 'when url is valid' do

      it 'creates the short url' do
        expect(page).to have_text(url.short_url)
      end

      it 'redirects to the home page' do
        expect(current_path).to eq('/urls')
        expect(page).to have_text(url.original_url)
      end
    end

    context 'when url is invalid' do
      let(:url_input) { 'youtubecom' }

      it 'does not create the short url and shows a message' do
        visit '/'
        # add more expections
      end

      it 'redirects to the home page' do
        visit '/'
        # add more expections
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      url = create(:url)
      visit visit_path(url.short_url)
      
      expect(current_url).to have_text(url.original_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')

        expect(page).to have_text("The page you were looking for doesn't exist.")
        expect(page).to have_text("You may have mistyped the address or the page may have moved.")
        expect(page).to have_text("If you are the application owner check the logs for more information.")
      end
    end
  end
end
