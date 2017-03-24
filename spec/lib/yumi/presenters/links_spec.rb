require 'spec_helper'
require_relative '../support/classes'

describe Yumi::Presenters::Links do
  let(:url) { "#{BASE_URL}/api/v1" }
  let(:resource) { Game.new(1) }
  let(:presenter) { Fake::GamePresenter.new(url, resource, Fake) }
  let(:klass) { Yumi::Presenters::Links.new(presenter) }

  describe '#to_json_api' do
    context 'when collection' do
      let(:resource) { [Game.new(1), Game.new(2)] }

      it 'returns /games' do
        expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games")
      end
    end

    context 'when single resource' do
      it 'returns /games/1' do
        expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games/1")
      end
    end
  end
end
