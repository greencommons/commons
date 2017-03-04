# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Resources", type: :request do
  let(:user) { create(:user) }
  let(:resource) { create(:resource) }
  let(:valid_attributes) { attributes_for(:resource) }
  let(:invalid_attributes) { attributes_for(:resource, title: nil) }

  describe "guest" do
    describe "GET /resources" do
      it "redirects to login page" do
        get resources_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe "GET /resources/:id" do
      it "gets 200" do
        get resource_path(resource)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "logged in user" do
    before { sign_in user }

    describe "GET /resources" do
      it "gets 200" do
        get resources_path
        expect(response).to have_http_status(200)
      end
    end

    describe "GET /resources/new" do
      it "gets 200" do
        get new_resource_path
        expect(response).to have_http_status(200)
      end
    end

    describe "POST /resources" do
      context "valid attributes" do
        it "gets redirected to resources_path" do
          post resources_path, params: { resource: valid_attributes }
          expect(response).to redirect_to Resource.last
        end

        it "creates the resource" do
          post resources_path, params: { resource: valid_attributes }
          expect(Resource.last.title).to eq valid_attributes[:title]
        end
      end

      context "invalid attributes" do
        it "does not redirect to resources_path" do
          post resources_path, params: { resource: invalid_attributes }
          expect(response).to have_http_status(200)
        end

        it "does not create the resource" do
          post resources_path, params: { resource: invalid_attributes }
          expect(Resource.last).to be nil
        end
      end
    end

    describe "GET /resources/edit" do
      it "gets 302" do
        get edit_resource_path(resource)
        expect(response).to have_http_status(302)
      end
    end

    describe "PATCH /resources/:id" do
      it "gets 302" do
        patch resource_path(resource)
        expect(response).to have_http_status(302)
      end
    end

    describe "resource owner" do
      let(:resource) { create(:resource, title: "Nice Resource", user: user) }
      before { sign_in user }

      describe "GET /resources/edit" do
        it "gets 200" do
          get edit_resource_path(resource)
          expect(response).to have_http_status(200)
        end
      end

      describe "PATCH /resources/:id" do
        context "valid attributes" do
          it "gets redirected to resources_path" do
            patch resource_path(resource), params: { resource: { title: "Better Resource" } }
            expect(response).to redirect_to resource
          end

          it "updates the resource" do
            patch resource_path(resource), params: { resource: { title: "Better Resource" } }
            expect(Resource.last.title).to eq "Better Resource"
          end
        end

        context "invalid attributes" do
          it "does not redirect to resources_path" do
            patch resource_path(resource), params: { resource: { title: nil } }
            expect(response).to have_http_status(200)
          end

          it "does not update the resource" do
            patch resource_path(resource), params: { resource: { title: nil } }
            expect(Resource.last.title).to eq "Nice Resource"
          end
        end
      end

      describe "DELETE /resources/:id" do
        it "gets redirected to resources_path" do
          delete resource_path(resource)
          expect(response).to redirect_to resources_path
        end

        it "deletes the resource" do
          delete resource_path(resource)
          expect(Resource.where(id: resource.id).first).to be nil
        end
      end
    end
  end
end
