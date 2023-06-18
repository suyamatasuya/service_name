class SymptomsController < ApplicationController
  def index
    @symptoms = Symptom.all
  end

  def new
    @symptom = Symptom.new
  end

  def create
    @symptom = Symptom.new(symptom_params)
    if @symptom.save
      redirect_to symptoms_path, notice: "Symptom was successfully created."
    else
      render :new
    end
  end

  private

  def symptom_params
    params.require(:symptom).permit(:pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end
end
