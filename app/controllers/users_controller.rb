class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_session_path(@user), notice: 'ユーザー作成に成功しました！' 
    else
      render :new
    end
end

  def edit; end

  def update
    if @user.update(user_params)
      SendNotificationJob.set(wait_until: @user.notification_time).perform_later(@user.device_token, "It's time to take care!")
      redirect_to root_path, notice: 'Notification time was successfully updated.'
    else
      render :edit
    end
  end  

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
