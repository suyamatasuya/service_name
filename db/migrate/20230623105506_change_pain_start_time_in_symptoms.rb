class ChangePainStartTimeInSymptoms < ActiveRecord::Migration[6.1]
  def up
    change_column :symptoms, :pain_start_time, :string
  end

  def down
    change_column :symptoms, :pain_start_time, :datetime
  end
end
