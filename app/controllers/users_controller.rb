class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      SendNotificationJob.set(wait_until: @user.notification_time).perform_later(@user.device_token, "It's time to take care!")
      redirect_to new_user_session_path, success: '登録成功!'
    else
      flash.now[:alert] = '登録失敗!'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      SendNotificationJob.set(wait_until: @user.notification_time).perform_later(@user.device_token, "It's time to take care!")
      redirect_to @user, notice: 'Notification time was successfully updated.'
    else
      render :edit
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :notification_time)
  end
end
