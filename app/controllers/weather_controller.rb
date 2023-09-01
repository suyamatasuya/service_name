# frozen_string_literal: true

# WeatherController handles weather-related actions.
class WeatherController < ApplicationController
  before_action :require_login, only: [:index]

  # Displays the weather index page.
  def index; end

  # Returns the Google API key as JSON.
  def google_api_key
    render json: { google_api_key: ENV['GOOGLE_API_KEY'] }
  end
end
