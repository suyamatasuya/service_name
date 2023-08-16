class AddSymptomToCareRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :care_records, :symptom, :string
  end
end
