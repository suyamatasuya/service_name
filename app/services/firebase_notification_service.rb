require 'google/cloud/firestore'
require 'bundler/setup'
Bundler.require(:default)
require 'google/apis/fcm_v1'

class FirebaseNotificationService
  FirebaseMessaging = Google::Apis::FcmV1
  def initialize
    @firestore = Google::Cloud::Firestore.new(
      project_id: 'care-time-reminder',
      credentials: '/Users/suyamatatsuya/Downloads/care-time-reminder-firebase-adminsdk-d0zmh-2c6a45ceee.json'
    )
    @fcm = FirebaseMessaging::FirebaseCloudMessagingService.new
    @fcm.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('Users/suyamatatsuya/Downloads/care-time-reminder-firebase-adminsdk-d0zmh-2c6a45ceee.json'),
      scope: 'https://www.googleapis.com/auth/firebase.messaging'
    )
  end

  def send_notification_to_all_users(message)
    # あなたのデータベースから全てのデバイストークンを取得する
    all_device_tokens = get_all_device_tokens()

    all_device_tokens.each do |device_token|
      message = Google::Apis::FcmV1::SendMessageRequest.new(
        message: {
          token: device_token,
          notification: {
            title: "Alert",
            body: message
          }
        }
      )
      response = @fcm.send_project_message('care-time-reminder', message)
      # 必要に応じてレスポンスを処理する
    end
  end

  def get_all_device_tokens
    User.pluck(:device_token)
  end  
end

firebase_notification_service = FirebaseNotificationService.new
firebase_notification_service.send_notification_to_all_users("痛みのケアをする時間です。")