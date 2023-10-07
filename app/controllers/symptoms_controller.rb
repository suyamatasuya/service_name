# frozen_string_literal: true

# SymptomsController handles the CRUD operations for Symptoms.
class SymptomsController < ApplicationController
  # Ensures the user is logged in.
  def require_login
    return if logged_in?

    flash[:alert] = t('controllers.symptoms.require_login.alert')
    redirect_to request.referrer || root_url
  end

  # Displays a list of all symptoms.
  def index
    @symptoms = Symptom.all
  end

  # Initializes a new symptom.
  def new
    @symptom = Symptom.new
  end

  # Creates a new symptom.
  def create
    initialize_symptom
    process_create
  end

  # Updates an existing symptom.
  def update
    @symptom = Symptom.find(params[:symptom_id])
    process_update
  end

  # Generates care methods based on the symptom's attributes.
  def generate_care_methods
    @symptom = Symptom.find(params[:id])
    @care_methods = @symptom.generate_care_methods
    @show_map = @symptom.pain_intensity.between?(8, 10)
  
    # エクササイズ情報をセッションに保存
    session[:care_methods_info] = @care_methods.as_json
  end

  private

  # Initializes a new symptom.
  def initialize_symptom
    @symptom = if current_user
                 current_user.symptoms.new(symptom_params.merge(current_step: 'pain_location'))
               else
                 Symptom.new(symptom_params.merge(current_step: 'pain_location'))
               end
  end

  # Processes the creation of a new symptom.
  def process_create
    if @symptom.save
      handle_successful_create
    else
      handle_failed_create
    end
  end

  # Handles a successful creation of a new symptom.
  def handle_successful_create
    session[:symptom_id] = @symptom.id
    redirect_to symptom_step_path(@symptom, :pain_location)
  end

  # Handles a failed creation of a new symptom.
  def handle_failed_create
    render :new
  end

  # Processes the update of an existing symptom.
  def process_update
    @symptom.update(symptom_params)
    render_wizard @symptom
  end

  # Strong parameters for symptom.
  def symptom_params
    params.require(:symptom).permit(:pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end
end
