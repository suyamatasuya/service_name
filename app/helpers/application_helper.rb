module ApplicationHelper
    def extract_video_id(url)
      if url.include?("youtu.be")
        url.split('/').last
      else
        url.split('=').last
      end
    end
  end
  