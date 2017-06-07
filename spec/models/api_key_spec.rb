# spec/models/api_key_spec.rb
require 'rails_helper'

RSpec.describe ApiKey, :type => :model do

  let(:key) { ApiKey.create }

  it 'is valid on creation' do
    expect(key).to be_valid
  end

  describe '#disable' do
    it 'disables the key' do
      key.disable
      expect(key.reload.active).to eq false
    end
  end
end
