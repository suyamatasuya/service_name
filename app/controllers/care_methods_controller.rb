class CareMethodsController < ApplicationController
  before_action :set_care_method, only: [:show, :edit, :update, :destroy]

  def new
    @care_method = CareMethod.new
    @symptoms = Symptom.all
  end
  
  def create
    @care_method = CareMethod.new(care_method_params)
    @symptoms = Symptom.all
    if @care_method.save
      flash[:notice] = t('controllers.care_methods.create.success')
      redirect_to @care_method
    else
      flash.now[:alert] = t('controllers.care_methods.create.failure')
      render :new
    end
  end  

  def show
    @care_methods = CareMethod.all
  end

  def edit
  end

  def update
    if @care_method.update(care_method_params)
      redirect_to @care_method, notice: t('controllers.care_methods.update.success')
    else
      render :edit
    end
  end

  def index
    @care_methods = CareMethod.all
  end
  
  def destroy
    @care_method.destroy
    redirect_to care_methods_path, notice: t('controllers.care_methods.destroy.success')
  end
  
  private

  def set_care_method
    @care_method = CareMethod.find(params[:id])
  end

  def care_method_params
    params.require(:care_method).permit(:name, :description, :video_links_and_titles, symptom_ids: [])
  end
end
