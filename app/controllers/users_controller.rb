class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_session_path, success: '登録成功!'
    else
      flash.now[:alert] = '登録失敗!'
      render :new
    end
  end
  # ...

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
