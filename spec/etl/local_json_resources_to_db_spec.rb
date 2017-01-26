require 'rails_helper'
require_relative '../../lib/etl/etl.rb'

RSpec.describe 'local_json_resources_to_db' do
  it 'extracts the valid JSON documents and generates resources' do
    ETL.run('lib/etl/local_json_resources_to_db.etl')
    expect(Resource.count).to eq 2
  end
end
