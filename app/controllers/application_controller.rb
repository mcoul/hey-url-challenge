# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def render_not_found
    render :file => "#{Rails.root}/public/404.html", status: :not_found
  end

  def bad_request(errors)
    render :file => "#{Rails.root}/public/400.html", status: :bad_request
  end
end
