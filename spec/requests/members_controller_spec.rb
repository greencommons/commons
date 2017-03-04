# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Groups", type: :request do
  let(:group) { create(:group) }

  context "guest" do
    describe "GET /groups/:id/members" do
      it "gets 200" do
        get group_members_path(group)
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /groups/:group_id/members/:id/make_admin" do
      it "redirects to login page" do
        john = create(:user, email: "john@example.com")
        group.add_user(john)

        post make_admin_group_member_path(group, group.find_member(john))
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context "regular group member" do
    let(:user) do
      user = create(:user)
      group.add_user(user)
      user
    end

    before { sign_in user }

    describe "GET /groups/:id/members" do
      it "gets 200" do
        get group_members_path(group)
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /groups/:id/members" do
      it "does not switch the user to admin for this group" do
        john = create(:user, email: "john@example.com")

        post group_members_path(group), params: { email: john.email }
        expect(group.find_member(john)).to be nil
      end
    end

    describe "POST /groups/:group_id/members/:id/make_admin" do
      it "does not switch the user to admin for this group" do
        john = create(:user, email: "john@example.com")
        group.add_user(john)

        post make_admin_group_member_path(group, group.find_member(john))
        expect(group.admin?(john)).to be false
      end
    end

    describe "POST /groups/:group_id/members/:id/remove_admin" do
      it "does not switch the user to admin for this group" do
        john = create(:user, email: "john@example.com")
        group.add_admin(john)

        post remove_admin_group_member_path(group, group.find_member(john))
        expect(group.admin?(john)).to be true
      end
    end

    describe "DELETE /groups/:group_id/members/:id" do
      it "does not switch the user to admin for this group" do
        john = create(:user, email: "john@example.com")
        group.add_user(john)
        john_group_user = group.find_member(john)

        delete group_member_path(group, john_group_user)
        expect(john_group_user.reload).not_to be nil
      end
    end

    describe "DELETE /groups/:group_id/members" do
      it "removes the current_user from the group" do
        delete leave_group_members_path(group)
        expect(group.find_member(user)).to be nil
      end
    end
  end

  context "group admin" do
    let(:user) do
      user = create(:user)
      group.add_admin(user)
      user
    end

    before { sign_in user }

    describe "GET /groups/:id/members" do
      it "gets 200" do
        get group_members_path(group)
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /groups/:id/members" do
      it "adds the user to the group and redirect to the group_members_path" do
        john = create(:user, email: "john@example.com")

        post group_members_path(group), params: { email: john.email }

        john_group_user = group.find_member(john)
        expect(john_group_user).not_to be nil
        expect(john_group_user.admin).to be false
        expect(response).to redirect_to group_members_path
      end
    end

    describe "POST /groups/:group_id/members/:id/make_admin" do
      it "switches the user to admin for this group and redirect to group_members_path" do
        john = create(:user, email: "john@example.com")
        group.add_user(john)

        post make_admin_group_member_path(group, group.find_member(john))
        expect(group.admin?(john)).to be true
        expect(response).to redirect_to group_members_path
      end
    end

    describe "POST /groups/:group_id/members/:id/remove_admin" do
      it "switches the user to admin for this group and redirect to group_members_path" do
        john = create(:user, email: "john@example.com")
        group.add_admin(john)

        post remove_admin_group_member_path(group, group.find_member(john))
        expect(group.admin?(john)).to be false
        expect(response).to redirect_to group_members_path
      end
    end

    describe "DELETE /groups/:group_id/members/:id" do
      it "switches the user to admin for this group and redirect to group_members_path" do
        john = create(:user, email: "john@example.com")
        group.add_user(john)

        delete group_member_path(group, group.find_member(john))
        expect(group.groups_users.where(user: john).first).to be nil
        expect(response).to redirect_to group_members_path
      end
    end

    describe "DELETE /groups/:group_id/members" do
      context "with multiple admins" do
        it "removes the current_user from the group" do
          john = create(:user, email: "john@example.com")
          group.add_admin(john)

          delete leave_group_members_path(group)
          expect(group.find_member(user)).to be nil
        end
      end

      context "with one admin" do
        it "does not remove the current_user from the group" do
          delete leave_group_members_path(group)
          expect(group.find_member(user)).not_to be nil
        end
      end
    end
  end
end
