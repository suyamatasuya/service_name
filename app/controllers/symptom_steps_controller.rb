class StepsController < ApplicationController
  include Wicked::Wizard

  steps :pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related

  def show
    @symptom = Symptom.find(params[:symptom_id])
    render_wizard
  end

  def update
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.update(symptom_params(step))
    render_wizard @symptom
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
