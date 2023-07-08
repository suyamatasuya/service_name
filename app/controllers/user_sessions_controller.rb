class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
  
    if @user&.valid_password?(params[:user][:password])
      # User was found and password is correct, log them in and redirect to root path
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'ログイン成功'
    else
      flash[:alert] = 'ログインに失敗しました。' # ここで flash を使います
      render :new
    end
  end  

  def destroy
    if logged_in?
      logout
      redirect_to root_path, notice: 'ログアウトしました！'
    else
      redirect_to root_path, notice: 'すでにログアウトしています'
    end
  end
end
