# frozen_string_literal: true

class AddPainLocationToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :pain_location, :string
  end
end
