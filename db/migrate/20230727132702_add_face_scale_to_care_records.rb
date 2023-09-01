# frozen_string_literal: true

class AddFaceScaleToCareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :care_records, :face_scale, :integer
  end
end
