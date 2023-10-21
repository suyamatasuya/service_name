# frozen_string_literal: true

module Api
  class CareRecordsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_care_record, only: %i[show destroy complete update]

    def index
      @care_records = current_user.care_records
      render json: @care_records, methods: :face_scale
    end

    def create
      care_types = care_record_params[:care_types]
      care_types.each do |care_type|
        current_user.care_records.build(date: care_record_params[:date], care_type: care_type, description: care_record_params[:description])
      end

      if current_user.save
        redirect_to care_records_path, notice: 'Care records were successfully created.'
      else
        render :new
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
      params.require(:care_record).permit(:date, :description, :completed, :symptom, care_types: [])
    end
  end
end
