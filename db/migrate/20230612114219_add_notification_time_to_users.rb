class AddNotificationTimeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :notification_time, :time
  end
end
