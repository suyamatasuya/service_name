# frozen_string_literal: true

class RemoveNotificationTimeFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :notification_time, :datetime
  end
end
