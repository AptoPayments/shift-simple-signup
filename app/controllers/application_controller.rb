class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :dwolla_client

  def dwolla_client
    Dwolla::api_key = ENV['DWOLLA_API_KEY']
    Dwolla::api_secret = ENV['DWOLLA_API_SECRET']
    Dwolla::sandbox = true if Rails.env.development?
  end
end
