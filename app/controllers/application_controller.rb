class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  # CORSヘッダーの設定
  before_action :set_cors_headers

  private

  def set_cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    # 必要に応じて他のCORS関連のヘッダーも追加できます
  end

  # クロスサイトのコンテキストでのCookie設定の例
  def set_cookie_for_cross_site
    cookies[:name] = {
      value: 'a value',
      expires: 1.year.from_now,
      same_site: :none,
      secure: true
    }
  end
end
