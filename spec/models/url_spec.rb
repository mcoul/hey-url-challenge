# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject(:url) { create(:url) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of :original_url }
  it { is_expected.to validate_presence_of :short_url }
  it { is_expected.to validate_uniqueness_of :original_url }
  it { is_expected.to validate_uniqueness_of :short_url }

  describe 'validations' do
    let(:invalid_original_url) { build(:url, :with_invalid_original_url) }
    let(:invalid_short_url) { build(:url, :with_invalid_short_url) }

    it 'validates original URL' do
      expect(invalid_original_url).not_to be_valid
    end

    it 'validates short URL' do
      expect(invalid_short_url).not_to be_valid
    end

    it 'clicks count starts at 0' do
      expect(url.clicks_count).to eq(0)
    end

    it 'validates short URL length is 5' do
      expect(url.short_url.length).to eq(5)
    end
  end
end
