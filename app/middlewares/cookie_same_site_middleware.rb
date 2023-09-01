# frozen_string_literal: true

class CookieSameSiteMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['Set-Cookie'] = process_cookies(headers['Set-Cookie']) if headers['Set-Cookie']
    [status, headers, body]
  end

  private

  def process_cookies(cookies)
    cookies = cookies.split("\n")
    cookies.map! do |cookie|
      process_cookie(cookie)
    end
    cookies.join("\n")
  end

  def process_cookie(cookie)
    return cookie unless cookie.is_a?(String)

    if cookie.include?('SameSite=None') && !cookie.include?('Secure')
      cookie << '; Secure'
    elsif cookie !~ /;\s*samesite=/i
      cookie << '; SameSite=Lax'
    end
    cookie
  end
end
