class CareRecordsController < ApplicationController
  before_action :require_login
  before_action :set_care_record, only: [:show, :edit, :update, :destroy]

  def index
    @care_records = current_user.care_records
  end

  def show
  end

  def new
    @care_record = current_user.care_records.build
  end

  def edit
  end

  def create
    @care_record = current_user.care_records.build(care_record_params)

    if @care_record.save
      redirect_to @care_record, notice: 'Care record was successfully created.'
    else
      render :new
    end
  end

  def update
    if @care_record.update(care_record_params)
      redirect_to @care_record, notice: 'Care record was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @care_record.destroy
    redirect_to care_records_url, notice: 'Care record was successfully destroyed.'
  end

  private
    
    def set_care_record
      @care_record = current_user.care_records.find(params[:id])
    end

    def care_record_params
      params.require(:care_record).permit(:date, :care_type, :duration, :notes, :symptom)
    end
end
