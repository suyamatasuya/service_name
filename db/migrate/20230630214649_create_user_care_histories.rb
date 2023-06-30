class CreateUserCareHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :user_care_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :care_method, null: false, foreign_key: true
      t.references :symptom, null: false, foreign_key: true
      t.date :care_received_date

      t.timestamps
    end
  end
end
