# frozen_string_literal: true

class CreateCareSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :care_settings do |t|
      t.datetime :care_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
