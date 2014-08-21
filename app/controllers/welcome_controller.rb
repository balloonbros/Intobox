class WelcomeController < ApplicationController
  include Mobylette::RespondToMobileRequests

  def index
    @mobile_request = is_mobile_request?
    redirect_to_secure home_path and return if !@mobile_request && logged_in?

    render layout: 'welcome'
  end

  def privacy_policy
    render layout: 'other'
  end

  def terms_of_service
    render layout: 'other'
  end
end
