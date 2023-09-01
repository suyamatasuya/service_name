# frozen_string_literal: true

class CreateCareMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :care_methods do |t|
      t.string :name
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end
