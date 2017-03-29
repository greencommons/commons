require 'spec_helper'
require_relative '../support/classes'

describe Yumi::Presenters::Data do
  let(:url) { "#{BASE_URL}/api/v1" }
  let(:resource) { Game.new(1) }
  let(:presenter) do
    Fake::GamePresenter.new(url, resource, Fake)
  end
  let(:klass) { Yumi::Presenters::Data.new(presenter) }

  before do
    allow_any_instance_of(Yumi::Presenters::Attributes).to receive(:to_json_api).
      and_return('attributes')
    allow_any_instance_of(Yumi::Presenters::Links).to receive(:to_json_api).
      and_return('links')
    allow_any_instance_of(Yumi::Presenters::Relationships).to receive(:to_json_api).
      and_return('relationships')
  end

  describe '#to_json_api' do
    it 'generates the data hash' do
      expect(klass.to_json_api).to eq(type: 'games',
                                      id: '1',
                                      attributes: 'attributes',
                                      links: 'links',
                                      relationships: 'relationships')
    end
  end
end
