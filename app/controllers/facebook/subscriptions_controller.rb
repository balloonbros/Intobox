class Facebook::SubscriptionsController < ApplicationController
  skip_before_action :authenticate_with_basic if Rails.env.staging?
  skip_before_action :verify_authenticity_token

  def new
    render text: params['hub.challenge']
  end

  def listen
    facebook1 = FacebookAuthenticate.where(facebook_id: params['entry'].first['uid']).first
    facebook2 = FacebookAuthenticate.where(facebook_id: params['entry'].second['uid']).first

    facebook1.user.rebuild_friend_list if facebook1
    facebook2.user.rebuild_friend_list if facebook2

    render nothing: true
  end
end
