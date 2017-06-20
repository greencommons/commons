require 'rails_helper'

RSpec.describe 'Networks', type: :request do
  let(:network) { create(:network) }

  context 'guest' do
    describe 'GET /networks/:id/members' do
      it 'gets 200' do
        get network_members_path(network)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /networks/:network_id/members/:id/make_admin' do
      it 'redirects to login page' do
        john = create(:user, email: 'john@example.com')
        network.add_user(john)

        post make_admin_network_member_path(network, network.find_member(john))
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'regular network member' do
    let(:user) do
      user = create(:user)
      network.add_user(user)
      user
    end

    before { sign_in user }

    describe 'GET /networks/:id/members' do
      it 'gets 200' do
        get network_members_path(network)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /networks/:id/members' do
      it 'does not switch the user to admin for this network' do
        john = create(:user, email: 'john@example.com')

        post network_members_path(network), params: { email: john.email }
        expect(network.find_member(john)).to be nil
      end
    end

    describe 'POST /networks/:network_id/members/:id/make_admin' do
      it 'does not switch the user to admin for this network' do
        john = create(:user, email: 'john@example.com')
        network.add_user(john)

        post make_admin_network_member_path(network, network.find_member(john))
        expect(network.admin?(john)).to be false
      end
    end

    describe 'POST /networks/:network_id/members/:id/remove_admin' do
      it 'does not switch the user to admin for this network' do
        john = create(:user, email: 'john@example.com')
        network.add_admin(john)

        post remove_admin_network_member_path(network, network.find_member(john))
        expect(network.admin?(john)).to be true
      end
    end

    describe 'DELETE /networks/:network_id/members/:id' do
      it 'does not switch the user to admin for this network' do
        john = create(:user, email: 'john@example.com')
        network.add_user(john)
        john_network_user = network.find_member(john)

        delete network_member_path(network, john_network_user)
        expect(john_network_user.reload).not_to be nil
      end
    end

    describe 'DELETE /networks/:network_id/members' do
      it 'removes the current_user from the network' do
        delete leave_network_members_path(network)
        expect(network.find_member(user)).to be nil
      end
    end
  end

  context 'network admin' do
    let(:user) do
      user = create(:user)
      network.add_admin(user)
      user
    end

    before { sign_in user }

    describe 'GET /networks/:id/members' do
      it 'gets 200' do
        get network_members_path(network)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /networks/:id/members' do
      it 'adds the user to the network and redirect to the network_members_path' do
        john = create(:user, email: 'john@example.com')

        post network_members_path(network), params: { email: john.email }

        john_network_user = network.find_member(john)
        expect(john_network_user).not_to be nil
        expect(john_network_user.admin).to be false
        expect(response).to redirect_to network_members_path
      end
    end

    describe 'POST /networks/:network_id/members/:id/make_admin' do
      it 'switches the user to admin for this network and redirect to network_members_path' do
        john = create(:user, email: 'john@example.com')
        network.add_user(john)

        post make_admin_network_member_path(network, network.find_member(john))
        expect(network.admin?(john)).to be true
        expect(response).to redirect_to network_members_path
      end
    end

    describe 'POST /networks/:network_id/members/:id/remove_admin' do
      it 'switches the user to admin for this network and redirect to network_members_path' do
        john = create(:user, email: 'john@example.com')
        network.add_admin(john)

        post remove_admin_network_member_path(network, network.find_member(john))
        expect(network.admin?(john)).to be false
        expect(response).to redirect_to network_members_path
      end
    end

    describe 'DELETE /networks/:network_id/members/:id' do
      it 'switches the user to admin for this network and redirect to network_members_path' do
        john = create(:user, email: 'john@example.com')
        network.add_user(john)

        delete network_member_path(network, network.find_member(john))
        expect(network.networks_users.where(user: john).first).to be nil
        expect(response).to redirect_to network_members_path
      end
    end

    describe 'DELETE /networks/:network_id/members' do
      context 'with multiple admins' do
        it 'removes the current_user from the network' do
          john = create(:user, email: 'john@example.com')
          network.add_admin(john)

          delete leave_network_members_path(network)
          expect(network.find_member(user)).to be nil
        end
      end

      context 'with one admin' do
        it 'does not remove the current_user from the network' do
          delete leave_network_members_path(network)
          expect(network.find_member(user)).not_to be nil
        end
      end
    end
  end
end
