class SymptomStepsController < ApplicationController
  include Wicked::Wizard

  steps :pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related

  def show
    @symptom = Symptom.find(params[:symptom_id])
    Rails.logger.debug "Current step: #{step}"
    if step == steps.first
      render steps.second
    else
      Rails.logger.debug "Rendering step template: #{step}"
      render_wizard
    end
  end
  
  
  def update
    @symptom = Symptom.find(params[:symptom_id])
    if @symptom.update(symptom_params(step))
      render_wizard @symptom
    else
      Rails.logger.debug "Failed to update symptom: #{@symptom.errors.full_messages.join(", ")}"
      render_wizard
    end
    Rails.logger.debug "Next step: #{step}"
  end
  
  

  private

  def symptom_params(step)
    permitted_attributes = case step
      when :pain_location
        [:pain_location]
      when :pain_type
        [:pain_type]
      when :pain_intensity
        [:pain_intensity]
      when :pain_start_time
        [:pain_start_time]
      when :injury_related
        [:injury_related]
    end

    params.require(:symptom).permit(permitted_attributes)
  end
end
