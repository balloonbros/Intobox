Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets.oauth.facebook.app, Rails.application.secrets.oauth.facebook.secret,
           :scope => 'email,xmpp_login',
           :callback_url => Settings.oauth.facebook.redirect_uri

  provider :dropbox_oauth2, Rails.application.secrets.oauth.dropbox.app, Rails.application.secrets.oauth.dropbox.secret,
           :callback_url => Settings.oauth.dropbox.redirect_uri
end
