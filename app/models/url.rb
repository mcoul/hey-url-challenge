# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :click

  validates_presence_of :original_url, :short_url
  validates_uniqueness_of :original_url, :short_url

  URL_REGEX = /\A((https?):\/\/)?(www\.)?[a-z0-9]+((\-\.){1}[a-z0-9]+)*\.[a-z]{2,4}(:[0-9]{1,4})?(\/.*)?\z/i.freeze
  validates :original_url, format: { with: URL_REGEX }

  validates_length_of :short_url, is: 5

  scope :latest, -> { order(created_at: :desc) }

  def sanitize_url
    self.original_url =~ /(https?):\/\// ? self.original_url : "https://#{self.original_url}"
  end
end
