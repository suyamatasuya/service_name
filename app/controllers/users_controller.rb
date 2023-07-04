class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :new_user, except: [:edit, :update]

  def new; end

  def create
    @user = User.new(user_params)
  
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'ユーザーが正常に登録されました。' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit; end

  def update
    if @user.update(user_params)
      SendNotificationJob.set(wait_until: @user.notification_time).perform_later(@user.device_token, "It's time to take care!")
      redirect_to @user, notice: 'Notification time was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def new_user
    @user = User.new
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :notification_time)
  end
end
