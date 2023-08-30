class WeatherController < ApplicationController
  before_action :require_login, only: [:index]
  
  def index
  end
  
  def google_api_key
    render json: { google_api_key: ENV["GOOGLE_API_KEY"] }
  end
end