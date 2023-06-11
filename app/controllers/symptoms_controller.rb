class SymptomsController < ApplicationController
  def new
    @symptom = Symptom.new
  end

  def create
    @symptom = current_user.symptoms.new(symptom_params) # Use current_user to associate the symptom with the current user
    
    if @symptom.save
      redirect_to symptom_step_path(@symptom, :pain_type)
    else
      render :new
    end
  end

  def show 
    @symptom = Symptom.find(params[:id])
    # Symptomの表示に関するコードを追加する
  end
  
  private
  
  def symptom_params
    params.require(:symptom).permit(:pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end  
end
