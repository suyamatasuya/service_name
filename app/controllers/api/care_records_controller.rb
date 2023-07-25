module Api
    class CareRecordsController < ApplicationController
      skip_before_action :verify_authenticity_token
  
      def index
        @care_records = CareRecord.all
        render json: @care_records
      end
  
      def create
        @care_record = current_user.care_records.new(care_record_params)
  
        if @care_record.save
          render json: @care_record, status: :created
        else
          render json: @care_record.errors, status: :unprocessable_entity
        end
      end
  
      def destroy
        care_record = CareRecord.find(params[:id])
        if care_record.destroy
          render json: { status: 'SUCCESS', message: 'Deleted the care_record', data: care_record }
        else
          render json: { status: 'ERROR', message: 'Not deleted', data: care_record.errors }
        end
      end
  
      def complete
        care_record = CareRecord.find(params[:id])
        care_record.update!(completed: true)
  
        render json: care_record
      end
  
      private
  
      def care_record_params
        params.require(:care_record).permit(:date, :care_type, :description, :completed)
      end
    end
  end
  