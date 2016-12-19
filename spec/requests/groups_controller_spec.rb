require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  let(:group) { create(:group) }
  let(:valid_attributes) { attributes_for(:group) }
  let(:invalid_attributes) { attributes_for(:group, name: nil) }

  describe 'unauthorized' do
    describe 'GET /groups' do
      it 'redirects to login page' do
        get groups_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'authorized' do
    before { sign_in create(:user) }

    describe 'GET /groups' do
      it 'gets 200' do
        get groups_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET /groups/new' do
      it 'gets 200' do
        get new_group_path
        expect(response).to have_http_status(200)
      end
    end

    describe 'GET /groups/edit' do
      it 'gets 200' do
        get edit_group_path(group)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /groups' do
      context 'valid attributes' do
        it 'gets redirected to groups_path' do
          post groups_path, params: { group: valid_attributes }
          expect(response).to redirect_to groups_path
        end

        it 'creates the group' do
          post groups_path, params: { group: valid_attributes }
          expect(Group.last.name).to eq valid_attributes[:name]
        end
      end

      context 'invalid attributes' do
        it 'does not redirect to groups_path' do
          post groups_path, params: { group: invalid_attributes }
          expect(response).to have_http_status(200)
        end

        it 'does not create the group' do
          post groups_path, params: { group: invalid_attributes }
          expect(Group.last).to be nil
        end
      end
    end

    describe 'PATCH /groups/:id' do
      let(:group) { create(:group, name: 'Nice Group') }

      context 'valid attributes' do
        it 'gets redirected to groups_path' do
          patch group_path(group), params: { group: { name: 'Better Group' } }
          expect(response).to redirect_to groups_path
        end

        it 'updates the group' do
          patch group_path(group), params: { group: { name: 'Better Group' } }
          expect(Group.last.name).to eq 'Better Group'
        end
      end

      context 'invalid attributes' do
        it 'does not redirect to groups_path' do
          patch group_path(group), params: { group: { name: nil } }
          expect(response).to have_http_status(200)
        end

        it 'does not update the group' do
          patch group_path(group), params: { group: { name: nil } }
          expect(Group.last.name).to eq 'Nice Group'
        end
      end
    end

    describe 'DELETE /groups/:id' do
      it 'gets redirected to groups_path' do
        delete group_path(group)
        expect(response).to redirect_to groups_path
      end

      it 'deletes the group' do
        delete group_path(group)
        expect(Group.where(id: group.id).first).to be nil
      end
    end
  end
end
