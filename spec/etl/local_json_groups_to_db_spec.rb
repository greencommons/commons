# frozen_string_literal: true
require "rails_helper"
require_relative "../../lib/etl/etl.rb"

RSpec.describe "local_json_groups_to_db" do
  it "extracts the valid JSON documents and generates groups" do
    ETL.run("lib/etl/local_json_groups_to_db.etl")
    expect(Group.count).to eq 4
  end
end
