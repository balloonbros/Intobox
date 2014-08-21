class TransferHistoriesController < ApplicationController
  before_filter :redirect_root_unless_login

  def receive
    @histories = current_user.
                 receive_transfer_histories.
                 includes(send_user: :facebook_authenticate).
                 order('created_at DESC').
                 page(params[:page] || 0)
  end

  def send_to
    @histories = current_user.
                 send_transfer_histories.
                 includes(receive_user: :facebook_authenticate).
                 order('created_at DESC').
                 page(params[:page] || 0)
  end
end
