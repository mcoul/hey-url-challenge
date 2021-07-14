# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  subject(:click) { create(:click) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to :url }
  it { is_expected.to validate_presence_of :browser }
  it { is_expected.to validate_presence_of :platform }

  describe 'validations' do
    let(:click_without_url_id) { build(:click, :without_url_id) }
    let(:click_with_invalid_browser) { build(:click, :with_invalid_browser) }
    let(:click_with_invalid_platform) { build(:click, :with_invalid_platform) }

    it 'validates url_id is valid' do
      expect(click_without_url_id).not_to be_valid
    end

    it 'validates browser' do
      expect(click_with_invalid_browser).not_to be_valid
    end

    it 'validates platform' do
      expect(click_with_invalid_platform).not_to be_valid
    end
  end
end
