class CreateCareRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :care_records do |t|
      t.date :date
      t.string :care_type
      t.integer :duration
      t.text :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
