# frozen_string_literal: true

class AddMorningAndEveningToCareSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :care_settings, :morning_care_time, :datetime
    add_column :care_settings, :evening_care_time, :datetime
  end
end
