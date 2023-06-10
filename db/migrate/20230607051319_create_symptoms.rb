class CreateSymptoms < ActiveRecord::Migration[6.1]
  def change
    create_table :symptoms do |t|
      t.references :user, null: false, foreign_key: true
      t.string :pain_location
      t.string :pain_type
      t.integer :pain_intensity
      t.datetime :pain_start_time
      t.integer :pain_duration

      t.timestamps
    end
  end
end
