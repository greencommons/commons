# frozen_string_literal: true
require_relative "../etl/etl"

REGISTERED_ETLS = [
  :local_epubs_to_db,
  :local_json_resources_to_db,
  :local_json_groups_to_db,
  :s3_islandpress_epubs_to_db,
  :s3_json_resources_to_db,
  :s3_json_groups_to_db,
].freeze

namespace :etl do
  REGISTERED_ETLS.each do |etl|
    desc "ETL task to import data: #{etl}"

    task etl => :environment do
      ETL.run("lib/etl/#{etl}.etl")
    end
  end
end
