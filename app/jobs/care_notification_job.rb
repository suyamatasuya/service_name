# frozen_string_literal: true

class CareNotificationJob < ApplicationJob
  queue_as :default

  def perform
    User.includes(:care_setting).find_each do |user|
      care_setting = user.care_setting
      send_care_notification(user, care_setting&.morning_care_time, '朝のケア時間です！')
      send_care_notification(user, care_setting&.evening_care_time, '夕方のケア時間です！')
    end
  end

  private

  # 指定されたケア時間が現在の時間と一致したら、ユーザーに通知を送る
  def send_care_notification(user, care_time, message)
    return unless care_time&.hour == Time.current.hour

    LineNotifier.new.send_message(user.line_uid, message)
  end
end
