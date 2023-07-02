class UserCareHistoriesController < ApplicationController
  before_action :require_login
  before_action :set_user_care_history, only: [:destroy]

  def index
    @user_care_histories = current_user.user_care_histories.includes(:care_method, :symptom).order(care_received_date: :desc)
  end

  def create
    puts "Debug: session[:symptom_id] = #{session[:symptom_id]}" # デバッグ用のコード

    care_method_ids = params[:care_method_ids] || []
    symptom = Symptom.find(session[:symptom_id]) # セッションからSymptomを取得します
    care_method_ids.each do |care_method_id|
      UserCareHistory.create!(
        user_id: current_user.id,
        care_method_id: care_method_id,
        symptom: symptom,
        care_received_date: Time.now
      )
    end
    redirect_to request.referrer || care_methods_path, notice: 'ケア方法が保存されました'
  end

  def destroy
    @user_care_history.destroy
    redirect_to user_care_histories_url, notice: 'ケア方法の履歴が削除されました'
  end

  private

  def set_user_care_history
    @user_care_history = UserCareHistory.find(params[:id])
  end

  def user_care_history_params
    params.require(:user_care_history).permit(:care_method_id, :symptom_id, :care_received_date)
  end
end
