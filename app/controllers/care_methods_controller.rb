class CareMethodsController < ApplicationController
  before_action :set_care_method, only: [:show, :edit, :update]

  def new
    @care_method = CareMethod.new
    @symptoms = Symptom.all # 新しいケア方法を作成する際に、どの症状に対するものかを選択できるようにすべての症状を取得
  end
  
  def create
    @care_method = CareMethod.new(care_method_params)
    @symptoms = Symptom.all # make sure to set @symptoms here too
    if @care_method.save
      flash[:notice] = 'ケア方法が保存されました'
      render :new
    else
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
      redirect_to @care_method, notice: 'Care method was successfully updated.'
    else
      render :edit
    end
  end

  def index
    @care_methods = CareMethod.all
  end
  
  def destroy
    @care_method = CareMethod.find(params[:id])
    @care_method.destroy
    redirect_to care_methods_path, notice: 'Care method was successfully deleted.'
  end
  
  private

  def set_care_method
    @care_method = CareMethod.find(params[:id])
  end

  def care_method_params
    params.require(:care_method).permit(:name, :description, :link, symptom_ids: [])
  end  
end