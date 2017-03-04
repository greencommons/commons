# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user, password: "commons") }
  let(:valid_attributes) do
    {
      current_password: "commons",
      password: "commons2",
      password_confirmation: "commons2",
    }
  end
  let(:invalid_attributes) do
    {
      current_password: "commons",
      password: "commons2",
      password_confirmation: "commons3",
    }
  end

  describe "guest" do
    describe "GET /profile/password" do
      it "redirects to login page" do
        get password_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "logged in user" do
    before { sign_in user }

    describe "GET /profile/password" do
      it "gets 200" do
        get password_path
        expect(response).to have_http_status(200)
      end
    end

    describe "PATCH /profile/password" do
      context "valid attributes" do
        it "gets redirected to password_path" do
          patch password_path, params: { user: valid_attributes }
          expect(response).to redirect_to profile_path
        end

        it "updates the user" do
          expect { patch(password_path, params: { user: valid_attributes }) }.to(
            change { user.reload.encrypted_password },
          )
        end
      end

      context "invalid attributes" do
        it "does not redirect to password_path" do
          patch password_path, params: { user: invalid_attributes }
          expect(response).to have_http_status(200)
        end

        it "does not update the user" do
          expect { patch(password_path, params: { user: invalid_attributes }) }.not_to(
            change { user.reload.encrypted_password },
          )
        end
      end
    end
  end
end
