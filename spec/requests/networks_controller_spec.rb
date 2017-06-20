require 'rails_helper'

RSpec.describe 'Networks', type: :request do
  let(:network) { create(:network) }
  let(:valid_attributes) { attributes_for(:network) }
  let(:invalid_attributes) { attributes_for(:network, name: nil) }

  describe 'guest' do
    describe 'GET /networks' do
      it 'redirects to login page' do
        get networks_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET /networks/:id' do
      it 'gets 200' do
        get network_path(network)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'regular network member' do
    before { sign_in create(:user) }

    describe 'GET /networks' do
      it 'gets 200' do
        get networks_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET /networks/new' do
      it 'gets 200' do
        get new_network_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /networks' do
      context 'valid attributes' do
        it 'gets redirected to networks_path' do
          post networks_path, params: { network: valid_attributes }
          expect(response).to redirect_to Network.last
        end

        it 'creates the network' do
          post networks_path, params: { network: valid_attributes }
          expect(Network.last.name).to eq valid_attributes[:name]
        end
      end

      context 'invalid attributes' do
        it 'does not redirect to networks_path' do
          post networks_path, params: { network: invalid_attributes }
          expect(response).to have_http_status(200)
        end

        it 'does not create the network' do
          post networks_path, params: { network: invalid_attributes }
          expect(Network.last).to be nil
        end
      end
    end

    describe 'GET /networks/edit' do
      it 'gets 302' do
        get edit_network_path(network)
        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'network admin' do
    let(:user) do
      user = create(:user)
      network.add_admin(user)
      user
    end

    before { sign_in user }

    describe 'GET /networks/edit' do
      it 'gets 200' do
        get edit_network_path(network)
        expect(response).to have_http_status(200)
      end
    end

    describe 'PATCH /networks/:id' do
      let(:network) { create(:network, name: 'Nice Network') }

      context 'valid attributes' do
        it 'gets redirected to networks_path' do
          patch network_path(network), params: { network: { name: 'Better Network' } }
          expect(response).to redirect_to network
        end

        it 'updates the network' do
          patch network_path(network), params: { network: { name: 'Better Network' } }
          expect(Network.last.name).to eq 'Better Network'
        end
      end

      context 'invalid attributes' do
        it 'does not redirect to networks_path' do
          patch network_path(network), params: { network: { name: nil } }
          expect(response).to have_http_status(200)
        end

        it 'does not update the network' do
          patch network_path(network), params: { network: { name: nil } }
          expect(Network.last.name).to eq 'Nice Network'
        end
      end
    end

    describe 'DELETE /networks/:id' do
      it 'gets redirected to networks_path' do
        delete network_path(network)
        expect(response).to redirect_to networks_path
      end

      it 'deletes the network' do
        delete network_path(network)
        expect(Network.where(id: network.id).first).to be nil
      end
    end
  end
end
