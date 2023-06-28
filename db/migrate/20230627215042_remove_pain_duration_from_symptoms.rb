class RemovePainDurationFromSymptoms < ActiveRecord::Migration[6.1]
  def change
    remove_column :symptoms, :pain_duration, :integer
  end
end
