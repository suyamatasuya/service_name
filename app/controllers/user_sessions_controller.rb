class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      respond_to do |format|
        flash.now[:notice] = 'ログイン成功'  # フラッシュメッセージをセット
        format.js { render 'success' } # success.js.erbを描画
        format.html { redirect_to root_path, notice: 'ログイン成功' }
      end
    else
      respond_to do |format|
        flash[:alert] = 'ログインに失敗しました。' # ここで flash を使います
        flash.keep[:alert] # このフラッシュメッセージを保持します
        format.js { render 'error' } # error.js.erbを描画
        format.html { render 'new', formats: :html }
      end
    end
  end  
  
  def destroy
    logout
    redirect_to root_path, notice: 'ログアウトしました！'
  end
end
