# frozen_string_literal: true

class AddDescriptionToCareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :care_records, :description, :text
  end
end
