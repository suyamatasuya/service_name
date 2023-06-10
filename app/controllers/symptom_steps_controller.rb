class SymptomStepsController < ApplicationController
  include Wicked::Wizard

  steps :new, :pain_type, :pain_intensity, :pain_start_time, :injury_related

  def show
    @symptom = Symptom.find(params[:symptom_id])
    render_wizard
  end

  def create
    @symptom = Symptom.new(symptom_params)
    if @symptom.save
      redirect_to next_wizard_path
    else
      render :new
    end
  end

  def update
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.update(symptom_params)
    render_wizard @symptom
  end

  private

  def symptom_params
    params.require(:symptom).permit(:pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end

  def next_wizard_path
    next_step = next_step(@symptom)
    if next_step == :new
      new_symptom_step_path(:new)
    else
      send("symptom_step_path", next_step)
    end
  end
end

