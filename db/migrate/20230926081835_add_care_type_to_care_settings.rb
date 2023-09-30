class AddCareTypeToCareSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :care_settings, :care_type, :string
  end
end
