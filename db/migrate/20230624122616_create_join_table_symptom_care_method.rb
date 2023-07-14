class CreateJoinTableSymptomCareMethod < ActiveRecord::Migration[6.1]
  def change
    create_table :care_methods_symptoms, id: false do |t|
      t.belongs_to :symptom
      t.belongs_to :care_method
    end
  end
end

