def stub_omniauth_for(provider, access_token)
  OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
    provider: provider.to_s,
    credentials: { token: access_token }
  })
  request.env['omniauth.auth'] = OmniAuth.config.mock_auth[provider] if defined?(request)
end

def random_access_token
  ((0..9).to_a + ("a".."z").to_a + ("A".."Z").to_a + [ '-', '_' ]).sample(64).join
end
