class SymptomsController < ApplicationController
  def new
    @symptom = Symptom.new
  end

  def create
    @symptom = Symptom.new(symptom_params)
    if @symptom.save
      redirect_to_next_wizard(@symptom)
    else
      render :new
    end
  end
  
  def update
    @symptom = Symptom.find(params[:id])
    if @symptom.update(symptom_params)
      redirect_to_next_wizard(@symptom)
    else
      render :edit
    end
  end

  def show
    @symptom = Symptom.find(params[:id])
  end
  
  private
  
  def symptom_params
    params.require(:symptom).permit(:pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end
end
