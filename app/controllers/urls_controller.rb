# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.latest.limit(10)
  end

  def create
    @url = Url.new(
      original_url: params[:url][:original_url],
      short_url: create_short_url
    )
    return bad_request(@url.errors) unless @url.save
    redirect_to action: 'index'
    flash[:notice] = "Created with success."
    return
  end

  def show
    @url = Url.find_by(short_url: params[:url]) or return render_not_found

    daily_array = Click.daily_clicks(@url.id).count.to_a
    @daily_clicks = daily_array.map { |x| [x[0].strftime("%d"), x[1]]}
    @browsers_clicks = Click.browsers_clicks(@url.id).count.to_a
    @platform_clicks = Click.platform_clicks(@url.id).count.to_a
  end

  def visit
    @url = Url.find_by(short_url: params[:short_url]) or return render_not_found

    @click = Click.new(url: @url, browser: browser.name, platform: browser.platform.name)

    return bad_request(@click.errors) unless @click.save

    @url.update(clicks_count: @url.clicks_count + 1)
    redirect_to @url.sanitize_url
  end


  private

  def create_short_url
    SecureRandom.uuid[0..4].upcase
  end
end
