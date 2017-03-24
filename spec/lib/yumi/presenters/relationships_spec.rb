require 'spec_helper'
require_relative '../support/classes'

describe Yumi::Presenters::Relationships do
  let(:url) { "#{BASE_URL}/api/v1" }
  let(:resource) { Game.new(1) }
  let(:presenter) { Fake::GamePresenter.new(url, resource, Fake) }
  let(:klass) { Yumi::Presenters::Relationships.new(presenter) }

  describe '#to_json_api' do
    it 'builds the relationships hash' do
      expect(klass.to_json_api).to include(:levels, :characters)
    end
  end
end
