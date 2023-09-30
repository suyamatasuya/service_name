require 'line/bot'

class LineNotifier
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token  = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def send_message(line_uid, message)
    message = {
      type: 'text',
      text: message
    }

    response = client.push_message(line_uid, message)
    # 必要に応じてエラーハンドリングなど
  end
end
