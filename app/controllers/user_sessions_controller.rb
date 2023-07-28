class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
  
    if @user&.valid_password?(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: t('controllers.user_sessions.create.success')
    else
      @user = User.new(email: params[:user][:email]) # Add this line
      flash[:alert] = t('controllers.user_sessions.create.failure') # Use flash here
      render :new
    end
  end  

  def destroy
    if logged_in?
      logout
      redirect_to root_path, notice: t('controllers.user_sessions.destroy.logout_success')
    else
      redirect_to root_path, notice: t('controllers.user_sessions.destroy.already_logged_out')
    end
  end
end
