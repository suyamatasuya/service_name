# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, ENV.fetch('LINE_CLIENT_ID', nil), ENV.fetch('LINE_CLIENT_SECRET', nil)
end
