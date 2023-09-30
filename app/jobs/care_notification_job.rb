class CareNotificationJob < ApplicationJob
    queue_as :default
  
    def perform
      current_time = Time.current
  
      User.includes(:care_setting).find_each do |user|
        care_setting = user.care_setting
  
        # 朝の通知
        if care_setting&.morning_care_time&.hour == current_time.hour
          LineNotifier.new.send_message(user.line_uid, "朝のケア時間です！")
        end
  
        # 夕方の通知
        if care_setting&.evening_care_time&.hour == current_time.hour
          LineNotifier.new.send_message(user.line_uid, "夕方のケア時間です！")
        end
      end
    end
  end
  