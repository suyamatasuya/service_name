# frozen_string_literal: true

# ApplicationController serves as the base class for all controllers in the application.
# It includes common functionalities and settings that are inherited by other controllers.
class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger
  before_action :set_cors_headers

  helper_method :current_user, :logged_in?

  private

  # Sets CORS headers to allow requests from any origin.
  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
  end

  # Ensures that a user is logged in. If not, redirects to the login page with a warning message.
  def ensure_user_logged_in
    unless logged_in?
      flash[:warning] = 'ログインしてください'
      redirect_to login_path # Use the correct path for your Sorcery login page.
    end
  end
end
