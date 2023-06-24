class AddCurrentStepToSymptoms < ActiveRecord::Migration[6.1]
  def change
    add_column :symptoms, :current_step, :string
  end
end
