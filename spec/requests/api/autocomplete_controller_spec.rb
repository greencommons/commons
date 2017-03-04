# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Api::AutocompleteController", type: :request do
  describe "unauthorized" do
    describe "GET /autocomplete/members" do
      it "redirects to login page" do
        get api_autocomplete_members_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "authorized" do
    describe "GET /autocomplete/members" do
      context "with group id" do
        context "without query" do
          it "gets 200" do
            group = create(:group)
            john = create(:user, email: "john@commons.org")

            sign_in(john)
            get api_autocomplete_members_path(group_id: group.id)
            expect(response).to have_http_status(200)
          end

          it "returns only the users that do not belong in the group" do
            group = create(:group)
            john = create(:user, email: "john@commons.org")
            mark = create(:user, email: "mark@commons.org")
            jack = create(:user, email: "jack@commons.org")

            group.add_user(john)
            group.add_user(mark)

            sign_in(john)
            get api_autocomplete_members_path(group_id: group.id)
            expect(json_body).to eq([{ "email" => jack.email }])
          end
        end

        context "with query=mark" do
          it "returns only the user that matches the query and does not belong in the group" do
            group = create(:group)
            john = create(:user, email: "john@commons.org")
            mark = create(:user, email: "mark@commons.org")
            create(:user, email: "jack@commons.org")

            group.add_user(john)

            sign_in(john)
            get api_autocomplete_members_path(group_id: group.id, q: "mark")
            expect(json_body).to eq([{ "email" => mark.email }])
          end
        end
      end

      context "without group id" do
        context "with query" do
          it "gets 200" do
            john = create(:user, email: "john@commons.org")

            sign_in(john)
            get api_autocomplete_members_path(q: "a")
            expect(response).to have_http_status(200)
          end

          it "returns all the matching users" do
            group = create(:group)
            john = create(:user, email: "john@commons.org")
            mark = create(:user, email: "mark@commons.org")
            jack = create(:user, email: "jack@commons.org")

            group.add_user(john)

            sign_in(john)
            get api_autocomplete_members_path(q: "a")
            expect(json_body).to eq([{ "email" => jack.email },
                                     { "email" => mark.email }])
          end
        end
      end
    end
  end
end
