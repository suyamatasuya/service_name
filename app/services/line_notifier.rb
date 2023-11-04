# frozen_string_literal: true

require 'line/bot'

class LineNotifier
  # clientメソッドをキャッシュするのではなく、常に新しいクライアントインスタンスを返します。
  # これにより、各メッセージの送信が独立していることが保証されます。
  def client
    Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET', nil)
      config.channel_token  = ENV.fetch('LINE_CHANNEL_TOKEN', nil)
    end
  end

  def send_message(line_uid, message_content)
    message = build_message(message_content)
    response = client.push_message(line_uid, message)
    log_response(response, line_uid)
    handle_response_failure(response, line_uid)
  rescue StandardError => e
    log_error(e, line_uid)
  end

  private

  # メッセージのハッシュを構築する専用のメソッドを作成
  def build_message(content)
    {
      type: 'text',
      text: content
    }
  end

  # レスポンスのログを出力するメソッド
  def log_response(response, line_uid)
    Rails.logger.info("LINE API Response to uid: #{line_uid}: #{response.body}")
  end

  # レスポンスが失敗した場合の処理をするメソッド
  def handle_response_failure(response, line_uid)
    return if response_success?(response.code)

    Rails.logger.error("Failed to send LINE message to uid: #{line_uid}. Error: #{response.body}")
  end

  # 成功のHTTPステータスコードかどうかをチェックするメソッド
  def response_success?(code)
    (200..299).include?(code)
  end

  # エラーをログに出力するメソッド
  def log_error(exception, line_uid)
    Rails.logger.error("Error sending LINE message to uid: #{line_uid}. Error: #{exception.message}")
  end
end
