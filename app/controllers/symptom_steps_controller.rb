class SymptomStepsController < ApplicationController
  include Wicked::Wizard

  steps :pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related, :generate_care_methods

  def show
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.current_step = step
    Rails.logger.debug "Current step: #{step}"
    
    if @symptom.pain_intensity && @symptom.pain_intensity >= 8 && @symptom.pain_intensity <= 10
      @show_map = true
    else
      @show_map = false
    end

    if step == steps.first
      render steps.second
    elsif step == :generate_care_methods
      @care_methods = @symptom.generate_care_methods
      render 'generate_care_methods'
    else
      Rails.logger.debug "Rendering step template: #{step}"
      render_wizard
    end
  end
  
  def update
    @symptom = Symptom.find(params[:symptom_id])
    Rails.logger.debug "Update action params: #{params.inspect}"
    Rails.logger.debug "Symptom id param before assignment: #{params[:symptom_id]}"

    if @symptom.update(symptom_params)
      Rails.logger.debug "After successful update: #{@symptom.inspect}"
      
      if @symptom.pain_intensity && @symptom.pain_intensity >= 8 && @symptom.pain_intensity <= 10
        @show_map = true
      else
        @show_map = false
      end

      if step == :generate_care_methods
        @care_methods = @symptom.generate_care_methods
      end
      render_wizard @symptom
    else
      Rails.logger.debug "Failed to update symptom: #{@symptom.errors.full_messages.join(", ")}"
      render_wizard
    end
    Rails.logger.debug "Next step: #{step}"
  end

  def finish_wizard_path
    symptom_step_path(@symptom, :generate_care_methods)
  end
  

  private

  def symptom_params
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
      when :generate_care_methods
        [:injury_related] # ここで追加
    end

    params.require(:symptom).permit(permitted_attributes)
  end
end
