# frozen_string_literal: true

class AddVideoTitleToCareMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :care_methods, :video_title, :string
  end
end
