require 'rails_helper'

RSpec.describe 'Profile', type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { attributes_for(:user, email: nil) }

  describe 'guest' do
    describe 'GET /profile' do
      it 'redirects to login page' do
        get profile_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'logged in user' do
    before { sign_in user }

    describe 'GET /profile' do
      it 'gets 200' do
        get profile_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'PATCH /profile' do
      context 'valid attributes' do
        it 'gets redirected to profile_path' do
          patch profile_path, params: { user: { bio: 'Something interesting' } }
          expect(response).to redirect_to profile_path
        end

        it 'updates the user' do
          patch profile_path, params: { user: { first_name: 'John' } }
          expect(User.last.first_name).to eq 'John'
        end
      end

      context 'invalid attributes' do
        it 'does not redirect to profile_path' do
          patch profile_path, params: { user: invalid_attributes }
          expect(response).to have_http_status(200)
        end

        it 'does not update the user' do
          patch profile_path, params: { user: invalid_attributes.merge(first_name: 'John') }
          expect(User.last.first_name).not_to eq 'John'
        end
      end
    end
  end
end
