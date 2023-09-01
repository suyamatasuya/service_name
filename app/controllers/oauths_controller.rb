# frozen_string_literal: true

# OauthsController handles OAuth authentication.
class OauthsController < ApplicationController
  include Sorcery::Controller::Submodules::External
  skip_before_action :require_login, raise: false

  # OAuth authentication start
  def oauth
    login_at(params[:provider])
  end

  # OAuth authentication callback
  def callback
    provider = params[:provider]
    Rails.logger.debug "Provider: #{provider}"
    @user = login_from(provider)

    if @user
      successful_login(provider)
    else
      handle_new_user(provider)
    end
  end

  private

  def successful_login(provider)
    reset_session
    auto_login(@user)
    redirect_to root_path, notice: "#{provider.titleize}でログインしました"
  end

  def handle_new_user(provider)
    Rails.logger.debug "login_from returned nil for provider: #{provider}"
    create_and_save_new_user(provider)
  end

  def create_and_save_new_user(provider)
    @user = create_from(provider)
    return redirect_to root_path, alert: "#{provider.titleize}でのユーザー登録に失敗しました" unless @user

    @user.save!
    Rails.logger.debug "User created from provider: #{@user.inspect}"
    successful_login(provider)
  rescue StandardError => e
    Rails.logger.error "Error during create_from: #{e.message}"
    redirect_to root_path, alert: "#{provider.titleize}でログインに失敗しました"
  end
end
