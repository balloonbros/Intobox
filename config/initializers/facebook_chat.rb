require 'facebook_chat'

FacebookChat::Client.configure do |config|
  config.api_key = Rails.application.secrets.oauth.facebook.app
end
