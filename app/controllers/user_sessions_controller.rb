# frozen_string_literal: true

# UserSessionsController handles user sessions.
class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    process_login
  end

  def destroy
    process_logout
  end

  private

  def process_login
    @user = User.find_by(email: params[:user][:email])
    if @user&.valid_password?(params[:user][:password])
      successful_login
    else
      failed_login
    end
  end

  def successful_login
    session[:user_id] = @user.id
    redirect_to root_path, notice: t('controllers.user_sessions.create.success')
  end

  def failed_login
    @user = User.new(email: params[:user][:email])
    flash[:alert] = t('controllers.user_sessions.create.failure')
    render :new
  end

  def process_logout
    if logged_in?
      logout
      redirect_to root_path, notice: t('controllers.user_sessions.destroy.logout_success')
    else
      redirect_to root_path, notice: t('controllers.user_sessions.destroy.already_logged_out')
    end
  end
end
