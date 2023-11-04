# frozen_string_literal: true

class WeatherController < ApplicationController
  before_action :require_login, only: [:index]

  def index
  end

  private

  def require_login
    unless logged_in?
      flash[:alert] = 'ログインしてください'
      redirect_to root_path
    end
  end
end
