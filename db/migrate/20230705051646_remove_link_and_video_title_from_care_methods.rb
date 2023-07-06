class RemoveLinkAndVideoTitleFromCareMethods < ActiveRecord::Migration[6.1]
  def change
    remove_column :care_methods, :link, :string
    remove_column :care_methods, :video_title, :string
  end
end
