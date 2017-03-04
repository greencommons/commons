# frozen_string_literal: true
require "rails_helper"
require_relative "../../lib/etl/etl.rb"

RSpec.describe "local_epubs_to_db" do
  it "extracts the valid EPUBs and generates resources" do
    ETL.run("lib/etl/local_epubs_to_db.etl")
    expect(Resource.count).to eq 2
  end
end
