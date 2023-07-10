require 'rails_helper'

RSpec.describe 'Custom Inboxes API', type: :request do
  let(:account) { create(:account) }
  let(:user) { create(:user, account: account, role: :agent) }
  let(:admin) { create(:user, account: account, role: :administrator) }
  let!(:custom_inbox) { create(:custom_inbox, account: account) }

  describe 'GET /api/v1/accounts/{account.id}/custom_inboxes' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}/custom_inboxes"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'returns all the custom inboxes in the account' do
        get "/api/v1/accounts/#{account.id}/custom_inboxes",
            headers: user.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:success)
        response_body = response.parsed_body
        expect(response_body.first['name']).to eq(custom_inbox.name)
        expect(response_body.count).to eq(1)
      end
    end
  end

  describe 'GET /api/v1/accounts/{account.id}/custom_inboxes/:id' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'shows the custom filter' do
        get "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}",
            headers: user.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:success)
        json_response = response.parsed_body
        expect(json_response['name']).to eq custom_inbox.name
      end
    end
  end

  describe 'POST /api/v1/accounts/{account.id}/custom_inboxes' do
    let(:payload) do
      {
        custom_inbox: {
          name: 'VIP Support',
          description: 'Inbox for all the paid users',
          icon: 'fluent:icon-add'
        }
      }
    end

    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        expect { post "/api/v1/accounts/#{account.id}/custom_inboxes", params: payload }.not_to change(CustomFilter, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an admin user' do
      it 'creates the inbox' do
        post "/api/v1/accounts/#{account.id}/custom_inboxes", headers: admin.create_new_auth_token,
                                                              params: payload

        expect(response).to have_http_status(:success)
        json_response = response.parsed_body
        expect(json_response['name']).to eq 'VIP Support'
      end
    end

    context 'when it is an agent user' do
      it 'return unauthorized' do
        post "/api/v1/accounts/#{account.id}/custom_inboxes", headers: user.create_new_auth_token,
                                                              params: payload

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH /api/v1/accounts/{account.id}/custom_inboxes/:id' do
    let(:payload) do
      {
        custom_inbox: {
          name: 'VIP Support',
          description: 'Inbox for all the paid users',
          icon: 'fluent:icon-add'
        }
      }
    end

    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        put "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}",
            params: payload

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an admin user' do
      it 'updates the custom filter' do
        expect(custom_inbox.name).to include('Custom inbox')

        patch "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}",
              headers: admin.create_new_auth_token,
              params: payload,
              as: :json

        expect(response).to have_http_status(:success)
        expect(custom_inbox.reload.name).to eq('VIP Support')
      end
    end

    context 'when it is an agent user' do
      it 'return unauthorized' do
        patch "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}", headers: user.create_new_auth_token,
                                                                                  params: payload

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/accounts/{account.id}/custom_inboxes/:id' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        delete "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated admin user' do
      it 'deletes custom filter if it is attached to the current user and account' do
        delete "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}",
               headers: admin.create_new_auth_token,
               as: :json
        expect(response).to have_http_status(:no_content)
        expect(account.custom_inboxes.count).to be 0
      end
    end

    context 'when it is an agent user' do
      it 'returns unauthorized' do
        delete "/api/v1/accounts/#{account.id}/custom_inboxes/#{custom_inbox.id}",
               headers: user.create_new_auth_token
        expect(response).to have_http_status(:unauthorized)
        expect(account.custom_inboxes.count).to be 1
      end
    end
  end
end
