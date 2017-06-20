require 'rails_helper'
require_relative '../../lib/etl/etl.rb'

RSpec.describe 'local_json_networks_to_db' do
  it 'extracts the valid JSON documents and generates networks' do
    ETL.run('lib/etl/local_json_networks_to_db.etl')
    expect(Network.count).to eq 4
  end
end
