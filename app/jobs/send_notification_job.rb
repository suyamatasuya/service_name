class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(device_token, message)
    service = FirebaseNotificationService.new
    service.send_notification(device_token, message)
  end
end