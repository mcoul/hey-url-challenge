# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  validates_presence_of :browser, :platform, :url
  validates_associated :url

  validate :valid_browser, :valid_platform

  scope :daily_clicks, ->(url_id) { where(url_id: 7, created_at: Date.today.all_month).group('DATE(created_at)') }
  scope :browsers_clicks, ->(url_id) { where(url_id: url_id).select(:browser).group(:browser) }
  scope :platform_clicks, ->(url_id) { where(url_id: url_id).select(:platform).group(:platform) }

  enum browsers: { IE: 0, Firefox: 1, Chrome: 2, Safari: 3 }
  enum platforms: { Windows: 0, macOS: 1, Ubuntu: 2 }

  private

  def valid_browser
    return unless browser
    errors.add(:click, "Invalid browser") unless self.class.browsers.keys.include?(browser)
  end

  def valid_platform
    return unless platform
    errors.add(:click, "Invalid platform") unless self.class.platforms.keys.include?(platform)
  end
end
