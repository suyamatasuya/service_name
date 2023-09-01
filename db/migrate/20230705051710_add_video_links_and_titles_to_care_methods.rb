# frozen_string_literal: true

class AddVideoLinksAndTitlesToCareMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :care_methods, :video_links, :text
    add_column :care_methods, :video_titles, :text
  end
end
