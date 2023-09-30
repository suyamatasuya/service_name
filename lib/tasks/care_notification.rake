namespace :care_notification do
    desc "Send care notification"
    task send: :environment do
      CareNotificationJob.perform_now
    end
  end