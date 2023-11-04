# frozen_string_literal: true

class CareSetting < ApplicationRecord
  belongs_to :user

  validate :either_morning_or_evening

  def send_morning_notification
    line_notifier = LineNotifier.new
    # ここでは「朝のケア時間です」というメッセージを送りますが、内容は変更してください。
    line_notifier.send_message(user.line_uid, '朝のケア時間です')
  end

  def send_evening_notification
    line_notifier = LineNotifier.new
    # ここでは「夜のケア時間です」というメッセージを送りますが、内容は変更してください。
    line_notifier.send_message(user.line_uid, '夜のケア時間です')
  end

  private

  def either_morning_or_evening
    return unless morning_care_time.blank? && evening_care_time.blank?

    errors.add(:base, '午前か午後のケア時間のどちらかは必ず入力してください')
  end
end
