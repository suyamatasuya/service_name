class CareSettingsController < ApplicationController

  def create
    @care_setting = current_user.build_care_setting(care_setting_params)  # build_care_setting を使用
    if @care_setting.save
      flash[:success] = "設定が正常に保存されました。"
      redirect_to care_records_path  # ここを変更
    else
      flash.now[:error] = @care_setting.errors.full_messages.join(", ")
      render :new
    end
  end

  def new
    @care_setting = current_user.build_care_setting  # build_care_setting を使用
  end
  
  private
  
  def care_setting_params
    params.require(:care_setting).permit(:morning_care_time, :evening_care_time)
  end  
end
