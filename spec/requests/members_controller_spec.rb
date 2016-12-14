require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  let(:group) { create(:group) }

  context 'unauthorized' do
    describe 'GET /groups/:id/members' do
      it 'gets 200' do
        get group_members_path(group)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /groups/:group_id/members/:id/make_admin' do
      let(:john) { create(:user, email: 'john@example.com') }
      let(:john_group_user) { group.find_member(john) }

      before { group.add_user(john) }

      it 'redirects to login page' do
        post make_admin_group_member_path(group, john_group_user)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'authorized' do
    let(:user) { create(:user) }

    before { sign_in user }

    describe 'GET /groups/:id/members' do
      it 'gets 200' do
        group.add_admin(user)
        get group_members_path(group)
        expect(response).to have_http_status(200)
      end
    end

    describe 'POST /groups/:group_id/members/:id/make_admin' do
      let(:john) { create(:user, email: 'john@example.com') }
      let(:john_group_user) { group.find_member(john) }

      before { group.add_user(john) }

      context 'when regular user' do
        it 'does not switch the user to admin for this group and redirect to group_members_path' do
          group.add_user(user)

          post make_admin_group_member_path(group, john_group_user)
          expect(group.admin?(john)).to be false
          expect(response).to redirect_to group_members_path
        end
      end

      context 'when admin' do
        it 'switches the user to admin for this group and redirect to group_members_path' do
          group.add_admin(user)

          post make_admin_group_member_path(group, john_group_user)
          expect(group.admin?(john)).to be true
          expect(response).to redirect_to group_members_path
        end
      end
    end

    describe 'POST /groups/:group_id/members/:id/remove_admin' do
      let(:john) { create(:user, email: 'john@example.com') }
      let(:john_group_user) { group.find_member(john) }

      context 'when regular user' do
        it 'does not switch the user to admin for this group and redirect to group_members_path' do
          group.add_user(user)
          group.add_admin(john)

          post remove_admin_group_member_path(group, john_group_user)
          expect(group.admin?(john)).to be true
          expect(response).to redirect_to group_members_path
        end
      end

      context 'when admin' do
        it 'switches the user to admin for this group and redirect to group_members_path' do
          group.add_admin(user)
          group.add_admin(john)

          post remove_admin_group_member_path(group, john_group_user)
          expect(group.admin?(john)).to be false
          expect(response).to redirect_to group_members_path
        end
      end
    end

    describe 'DELETE /groups/:group_id/members/:id' do
      let(:john) { create(:user, email: 'john@example.com') }
      let(:john_group_user) { group.groups_users.where(user: john).first }

      before { group.add_user(john) }

      context 'when regular user' do
        it 'does not switch the user to admin for this group and redirect to group_members_path' do
          group.add_user(user)

          delete group_member_path(group, john_group_user)
          expect(john_group_user.reload).not_to be nil
          expect(response).to redirect_to group_members_path
        end
      end

      context 'when admin' do
        it 'switches the user to admin for this group and redirect to group_members_path' do
          group.add_admin(user)

          delete group_member_path(group, john_group_user)
          expect(group.groups_users.where(user: john).first).to be nil
          expect(response).to redirect_to group_members_path
        end
      end
    end
  end
end
