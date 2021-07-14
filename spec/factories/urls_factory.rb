# frozen_string_literal: true

FactoryBot.define do
  factory :url do
    short_url { SecureRandom.uuid[0..4].upcase }
    sequence(:original_url) { |i| "https://domain#{i}.com/path" }
    clicks_count { 0 }
  end

  trait :with_invalid_original_url do
    original_url { INVALID_URLS.sample }
  end

  trait :with_invalid_short_url do
    short_url { INVALID_URLS.sample }
  end
end


INVALID_URLS = [
  "htp://google.com",
  "googlecom",
  "https:/wwwgoogle.ar"
]

INVALID_SHORT_URLS = [
  SecureRandom.uuid[0..4],
  SecureRandom.uuid[0..6].upcase,
  SecureRandom.uuid[0..2].upcase
]
