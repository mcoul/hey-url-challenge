FactoryBot.define do
  factory :click do
    url_id { FactoryBot.create(:url).id }
    browser { Click.browsers.keys.sample }
    platform { Click.platforms.keys.sample }
  end

  trait :without_url_id do
    url_id { 'f' }
  end

  trait :with_invalid_browser do
    browser { "invalid browser" }
  end

  trait :with_invalid_platform do
    platform { "invalid platform" }
  end
end
