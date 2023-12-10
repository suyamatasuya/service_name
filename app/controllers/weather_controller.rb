# frozen_string_literal: true

class WeatherController < ApplicationController
  before_action :require_login, only: [:index]

  def index
  end

  def google_api_key
    api_key = ENV['GOOGLE_API_KEY'] || 'your-default-api-key'
    render json: { google_api_key: api_key }
  end

  private

  def require_login
    unless logged_in?
      flash[:alert] = 'ログインしてください'
      redirect_to root_path
    end
  end
end
