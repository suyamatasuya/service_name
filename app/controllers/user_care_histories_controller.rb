# frozen_string_literal: true

# UserCareHistoriesController manages user care histories.
class UserCareHistoriesController < ApplicationController
  before_action :require_login
  before_action :set_user_care_history, only: [:destroy]

  # Display a list of user care histories.
  def index
    @user_care_histories = current_user.user_care_histories
                                       .includes(:care_method, :symptom)
                                       .order(care_received_date: :desc)
    @selected_care_methods = @user_care_histories.map(&:care_method).uniq
  end

  # Create a new user care history.
  def create
    if create_user_care_histories
      redirect_to request.referrer || care_methods_path, notice: t('controllers.user_care_histories.create.notice')
    else
      redirect_to request.referrer || care_methods_path, alert: t('controllers.user_care_histories.create.alert')
    end
  end

  # Destroy a user care history.
  def destroy
    @user_care_history.destroy
    redirect_to user_care_histories_url, notice: t('controllers.user_care_histories.destroy.notice')
  end

  private

  # Set a user care history.
  def set_user_care_history
    @user_care_history = UserCareHistory.find(params[:id])
  end

  # Create user care histories based on the provided care method IDs.
  def create_user_care_histories
    symptom = Symptom.find_by(id: session[:symptom_id])
    return false unless symptom

    care_method_ids = params[:care_method_ids] || []
    care_method_ids.each do |id|
      create_single_user_care_history(id, symptom)
    end
    true
  end

  def create_single_user_care_history(id, symptom)
    UserCareHistory.create!(
      user_id: current_user.id,
      care_method_id: id,
      symptom:,
      care_received_date: Time.now
    )
  end

  # Strong parameters for user care history.
  def user_care_history_params
    params.require(:user_care_history).permit(:care_method_id, :symptom_id, :care_received_date)
  end
end
