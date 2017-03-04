# frozen_string_literal: true
require "rails_helper"

RSpec.describe UserFilter do
  describe "#run" do
    context "when group_id is given to scope down the results" do
      context "when the group contains users" do
        it "returns all the users not belonging to the given group" do
          group = create(:group)
          john = create(:user, email: "john@commons.org")
          create(:user, email: "mark@commons.org")
          create(:user, email: "jack@commons.org")

          group.add_user(john)

          users = UserFilter.new(query: "comm", group_id: group.id).run
          expect(users.map(&:email)).not_to include("john@commons.org")
          expect(users.map(&:email)).to include("mark@commons.org",
                                                "jack@commons.org")
        end

        it "returns no users when the only matching user belongs to the group" do
          group = create(:group)
          john = create(:user, email: "john@commons.org")
          create(:user, email: "mark@commons.org")
          create(:user, email: "jack@commons.org")

          group.add_user(john)

          users = UserFilter.new(query: "jo", group_id: group.id).run
          expect(users).to eq([])
        end
      end

      context "when the group has no users" do
        it "returns all the users with query=comm" do
          group = create(:group)
          create(:user, email: "john@commons.org")
          create(:user, email: "mark@commons.org")
          create(:user, email: "jack@commons.org")

          users = UserFilter.new(query: "comm", group_id: group.id).run
          expect(users.map(&:email)).to include("john@commons.org",
                                                "mark@commons.org",
                                                "jack@commons.org")
        end
      end
    end

    context "when group_id is nil" do
      it "returns all the users with query=comm" do
        create(:user, email: "john@commons.org")
        create(:user, email: "mark@commons.org")
        create(:user, email: "jack@commons.org")

        users = UserFilter.new(query: "comm").run
        expect(users.map(&:email)).to include("john@commons.org",
                                              "mark@commons.org",
                                              "jack@commons.org")
      end

      it "returns john with query=jo" do
        create(:user, email: "john@commons.org")
        create(:user, email: "mark@commons.org")
        create(:user, email: "jack@commons.org")

        users = UserFilter.new(query: "jo").run
        expect(users.map(&:email)).to eq(["john@commons.org"])
      end
    end
  end
end
