#
# Intoboxを利用するためにFacebookとDropboxの認証を
# 完了させたユーザーを作ってログイン状態にしておきます。
#
# [引数]
#   user Facebookのユーザー。シンボルで指定します。
#        デフォルトは :me (自分自身) です。
#
def prepare_user_to_use_intobox(user = :me)
  facebook_access_token = random_access_token
  dropbox_access_token  = random_access_token

  OmniAuth.config.test_mode = true
  stub_omniauth_for(:facebook, facebook_access_token)
  stub_omniauth_for(:dropbox_oauth2, dropbox_access_token)

  user = User.entry_by_facebook_for_test(user, facebook_access_token)

  stub_request_for_dropbox_account

  visit '/auth/facebook'
  visit '/auth/dropbox_oauth2'

  all('.tutorial-box-closer', visible: true).each {|box| box.trigger('click') }

  return user
end
