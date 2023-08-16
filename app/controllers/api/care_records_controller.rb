module Api
  class CareRecordsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_care_record, only: [:show, :destroy, :complete, :update]

    def index
      @care_records = current_user.care_records
      render json: @care_records, methods: :face_scale
    end

    def create
      @care_record = current_user.care_records.new(care_record_params)

      if @care_record.save
        render json: @care_record, status: :created
      else
        render json: @care_record.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @care_record, methods: :face_scale
    end

    def destroy
      if @care_record.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the care_record', data: @care_record }
      else
        render json: { status: 'ERROR', message: 'Not deleted', data: @care_record.errors }
      end
    end

    def complete
      @care_record.update!(completed: true, face_scale: params[:face_scale])
      render json: @care_record
    end
    
    def delete_by_symptom
      current_user.care_records.where(symptom: params[:symptom]).destroy_all
      render json: { status: 'SUCCESS', message: "#{params[:symptom].capitalize} records deleted" }
    end

    def update
      @care_record = current_user.care_records.find(params[:id])
    
      if @care_record.update(care_record_params)
        render json: @care_record, status: :ok
      else
        render json: @care_record.errors, status: :unprocessable_entity
      end
    end    

    private

    def set_care_record
      @care_record = current_user.care_records.find(params[:id])
    end

    def care_record_params
      params.require(:care_record).permit(:date, :care_type, :description, :completed, :symptom)
    end    
  end
end
