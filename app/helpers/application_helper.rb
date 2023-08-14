module ApplicationHelper
  def extract_video_id(url)
    return nil unless url

    # youtu.be 形式のURLからの動画IDの抽出
    if url.include?("youtu.be")
      url.split('/').last
    # 標準的なYouTubeのURL形式からの動画IDの抽出
    elsif match = url.match(/v=([\w\-]+)/)
      match[1]
    else
      nil
    end
  end
end
