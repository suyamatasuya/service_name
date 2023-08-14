class CookieSameSiteMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    if headers["Set-Cookie"]
      cookies = headers["Set-Cookie"].split("\n")

      cookies.map! do |cookie| # map!を使用して、配列の内容を直接変更
        next cookie unless cookie.is_a?(String) # cookieが文字列でない場合、そのまま返す

        if cookie.include?("SameSite=None") && !cookie.include?("Secure")
          cookie << "; Secure"
        elsif !(cookie =~ /;\s*samesite=/i)
          cookie << "; SameSite=Lax"
        end
        cookie
      end

      headers["Set-Cookie"] = cookies.join("\n")
    end

    [status, headers, body]
  end
end
