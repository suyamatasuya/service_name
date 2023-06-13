class SymptomStepsController < ApplicationController
  include Wicked::Wizard

  steps :pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related

  def show
    @symptom = Symptom.find(params[:symptom_id])
    render_wizard
  end

  def update
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.update(symptom_params)
    render_wizard @symptom
  end

  def next_wizard_path
    case step
    when :pain_location
      symptom_step_path(@symptom, :pain_type)
    when :pain_type
      symptom_step_path(@symptom, :pain_intensity)
    when :pain_intensity
      symptom_step_path(@symptom, :pain_start_time)
    when :pain_start_time
      symptom_step_path(@symptom, :injury_related)
    when :injury_related
      completed_wizard_path
    else
      nil
    end
  end
  
  

  private

  def symptom_params
    params.require(:symptom).permit(:pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end
end
