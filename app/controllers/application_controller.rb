class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :dwolla_client

  def dwolla_client
    @redirect_uri = url_for(:oauth_return)
    Dwolla::api_key = ENV['DWOLLA_API_KEY']
    Dwolla::api_secret = ENV['DWOLLA_API_SECRET']
    Dwolla::sandbox = true if Rails.env.development?
  end
end
