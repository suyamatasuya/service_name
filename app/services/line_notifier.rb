require 'line/bot'

class LineNotifier
  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token  = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def send_message(line_uid, message_content)
    message = {
      type: 'text',
      text: message_content
    }
  
    response = client.push_message(line_uid, message)
  
    # LINE APIからのレスポンス内容をログに出力
    Rails.logger.info("LINE API Response: #{response.body}")
  
    # 200の代わりに、成功のHTTPステータスコードの範囲をチェック
    if !(200..299).include?(response.code)
      Rails.logger.error("Failed to send LINE message to uid: #{line_uid}. Error: #{response.body}")
    end
  rescue => e
    Rails.logger.error("Error sending LINE message to uid: #{line_uid}. Error: #{e.message}")
  end  
end