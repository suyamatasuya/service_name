# frozen_string_literal: true

# SymptomStepsController handles the step-by-step process for creating and updating Symptoms.
class SymptomStepsController < ApplicationController
  include Wicked::Wizard
  steps :pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related, :generate_care_methods

  # Displays the current step in the symptom creation process.
  def show
    setup_show
    render_show
  end

  # Updates the symptom based on the current step.
  def update
    setup_update
    process_update
  end

  # Defines the path to go to after the wizard is finished.
  def finish_wizard_path
    symptom_step_path(@symptom, :generate_care_methods)
  end

  private

  def setup_show
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.current_step = step
    @show_map = @symptom.pain_intensity&.between?(8, 10)
  end

  def render_show
    if step == steps.first
      render steps.second
    elsif step == :generate_care_methods
      @care_methods = @symptom.generate_care_methods
      render 'generate_care_methods'
    else
      render_wizard
    end
  end

  def setup_update
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.assign_attributes(symptom_params)
  end

  def process_update
    if @symptom.valid?(step)
      finalize_update
    else
      flash[:alert] = t('controllers.symptom_steps.update.alert')
      render_wizard
    end
  end

  def finalize_update
    @symptom.save
    @show_map = @symptom.pain_intensity&.between?(8, 10)
    @care_methods = @symptom.generate_care_methods if step == :generate_care_methods
    render_wizard @symptom
  end

  # Strong parameters for symptom based on the current step.
  def symptom_params
    permitted_attributes = {
      pain_location: [:pain_location],
      pain_type: [:pain_type],
      pain_intensity: [:pain_intensity],
      pain_start_time: [:pain_start_time],
      injury_related: [:injury_related],
      generate_care_methods: [:injury_related]
    }
    params.fetch(:symptom, {}).permit(permitted_attributes[step.to_sym])
  end
end
