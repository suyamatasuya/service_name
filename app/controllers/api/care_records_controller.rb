# frozen_string_literal: true

# Api module serves as the namespace for all API controllers.
module Api
  # CareRecordsController handles the CRUD operations for CareRecords in the API.
  class CareRecordsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_care_record, only: %i[show destroy complete update]

    # Displays a list of care records for the current user.
    def index
      @care_records = current_user.care_records
      render json: @care_records, methods: :face_scale
    end

    # Creates a new care record.
    def create
      @care_record = current_user.care_records.new(care_record_params)

      if @care_record.save
        render json: @care_record, status: :created
      else
        render json: @care_record.errors, status: :unprocessable_entity
      end
    end

    # Displays a single care record.
    def show
      render json: @care_record, methods: :face_scale
    end

    # Deletes a care record.
    def destroy
      if @care_record.destroy
        render json: { status: 'SUCCESS', message: 'Deleted the care_record', data: @care_record }
      else
        render json: { status: 'ERROR', message: 'Not deleted', data: @care_record.errors }
      end
    end

    # Marks a care record as complete.
    def complete
      @care_record.update!(completed: true, face_scale: params[:face_scale])
      render json: @care_record
    end

    # Deletes care records by symptom.
    def delete_by_symptom
      current_user.care_records.where(symptom: params[:symptom]).destroy_all
      render json: { status: 'SUCCESS', message: "#{params[:symptom].capitalize} records deleted" }
    end

    # Updates an existing care record.
    def update
      @care_record = current_user.care_records.find(params[:id])

      if @care_record.update(care_record_params)
        render json: @care_record, status: :ok
      else
        render json: @care_record.errors, status: :unprocessable_entity
      end
    end

    private

    # Sets the care record for actions like show, destroy, complete, and update.
    def set_care_record
      @care_record = current_user.care_records.find(params[:id])
    end

    # Strong parameters for care record.
    def care_record_params
      params.require(:care_record).permit(:date, :care_type, :description, :completed, :symptom)
    end
  end
end
