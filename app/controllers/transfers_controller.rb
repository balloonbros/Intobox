class TransfersController < ApplicationController
  before_action :login_check

  def create
    @transferer = current_user.build_transfer_file(params[:transfer])
    result = @transferer.transfer

    response.headers['Content-Type'] = 'text/plain'
    render json: { success: result, error: @transferer.errors.messages.values.flatten.first }
  end

  private

  def login_check
    unless logged_in?
      render json: { success: false, error: I18n.t('errors.session_expired') }
    end
  end
end
