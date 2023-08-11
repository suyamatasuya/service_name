class SymptomStepsController < ApplicationController
  include Wicked::Wizard
  steps :pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related, :generate_care_methods

  def show
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.current_step = step
    
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
      render_wizard
    end
  end
  
  def update
    @symptom = Symptom.find(params[:symptom_id])

    @symptom.assign_attributes(symptom_params)

    if @symptom.valid?(step)
      @symptom.save
  
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
      flash[:alert] = t('controllers.symptom_steps.update.alert')
      render_wizard
    end
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
        [:injury_related]
    end

    params.fetch(:symptom, {}).permit(permitted_attributes)
  end
end
