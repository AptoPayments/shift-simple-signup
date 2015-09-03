class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :dwolla_client

  def dwolla_client
    Dwolla::api_key = Rails.application.secrets.dwolla_api_key
    Dwolla::api_secret = Rails.application.secrets.dwolla_api_secret
    Dwolla::sandbox = true if Rails.env.development?
  end
end
