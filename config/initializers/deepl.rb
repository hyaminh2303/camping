DeepL.configure do |config|
  config.auth_key = Rails.application.credentials[:deepl_auth_key]
end