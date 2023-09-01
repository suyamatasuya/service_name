# frozen_string_literal: true

# ApplicationController serves as the base class for all controllers in the application.
# It includes common functionalities and settings that are inherited by other controllers.
class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  # Sets CORS headers for cross-origin requests.
  before_action :set_cors_headers

  private

  # Sets the CORS headers to allow requests from any origin.
  # Additional CORS-related headers can be added as needed.
  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  # Example of setting a cookie for cross-site contexts.
  # This sets a secure cookie with the SameSite attribute set to 'None'.
  def set_cookie_for_cross_site
    cookies[:name] = {
      value: 'a value',
      expires: 1.year.from_now,
      same_site: :none,
      secure: true
    }
  end
end
