class Api::V1::Accounts::CustomInboxesController < Api::V1::Accounts::BaseController
  before_action :check_authorization
  before_action :fetch_custom_inboxes, except: [:create]
  before_action :fetch_custom_inbox, only: [:show, :update, :destroy]

  def index; end

  def show; end

  def create
    @custom_inbox = Current.account.custom_inboxes.create!(
      permitted_payload.merge(account_id: Current.account.id)
    )
  end

  def update
    @custom_inbox.update!(permitted_payload)
  end

  def destroy
    @custom_inbox.destroy!
    head :no_content
  end

  private

  def fetch_custom_inboxes
    @custom_inboxes = Current.account.custom_inboxes
  end

  def fetch_custom_inbox
    @custom_inbox = @custom_inboxes.find(permitted_params[:id])
  end

  def permitted_payload
    params.require(:custom_inbox).permit(
      :name,
      :description,
      :icon
    )
  end

  def permitted_params
    params.permit(:id)
  end
end
