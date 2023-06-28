class CreateJoinTableSymptomCareMethod < ActiveRecord::Migration[6.1]
  def change
    create_table :symptoms_care_methods, id: false do |t|
      t.belongs_to :symptom
      t.belongs_to :care_method
    end
  end
end
