# frozen_string_literal: true

class AddCompletedToCareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :care_records, :completed, :boolean
  end
end
