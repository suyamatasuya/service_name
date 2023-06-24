class SymptomsController < ApplicationController
  def index
    @symptoms = Symptom.all
  end

  def new
    @symptom = Symptom.new
  end

  def create
    @symptom = current_user.symptoms.new(symptom_params.merge(current_step: 'pain_location'))
    if @symptom.save
      redirect_to symptom_step_path(@symptom, :pain_location)
    else
      puts "Error: Symptom not saved"
      puts "Params: #{params.inspect}"
      puts @symptom.errors.full_messages
      render :new
    end
  end

  def update
    @symptom = Symptom.find(params[:symptom_id])
    @symptom.update(symptom_params)
    
    if @symptom.valid?
      # バリデーションが成功した場合の処理
      if step == steps.last
        # 最後のステップの場合、結果を生成して表示するなどの処理を行う
        redirect_to finish_wizard_path
      else
        # 次のステップに進む
        render_wizard @symptom
      end
    else
      # バリデーションが失敗した場合の処理
      render_wizard @symptom
    end
  end

  def generate_care_methods
    @symptom = Symptom.find(params[:id])
    byebug
    puts "Found symptom: #{@symptom.inspect}"
    puts "Pain start time: #{@symptom.pain_start_time}"
    puts @symptom.generate_care_methods.inspect
    @care_methods = @symptom.generate_care_methods
  end
  
  private

  def symptom_params
    params.require(:symptom).permit(:pain_location, :pain_type, :pain_intensity, :pain_start_time, :injury_related)
  end
end
