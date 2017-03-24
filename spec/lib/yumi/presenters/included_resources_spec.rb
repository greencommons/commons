require 'spec_helper'
require_relative '../support/classes'

describe Yumi::Presenters::IncludedResources do
  let(:url) { "#{BASE_URL}/api/v1" }
  let(:resource) { Game.new(1) }
  let(:presenter) { Fake::GamePresenter.new(url, resource, Fake) }
  let(:klass) { Yumi::Presenters::Data.new(presenter) }
  let(:included_resources) { {} }

  let(:klass) { Yumi::Presenters::IncludedResources.new(presenter, includes, included_resources) }

  describe '#to_json_api' do
    context 'with includes specified' do
      let(:includes) { %w(levels characters) }

      context 'when resource is a collection' do
        let(:game) { Game.new(1) }
        let(:resource) { [game, game, Game.new(2)] }

        it 'returns an array of included resources without duplicates' do
          expect(klass.to_json_api.count).to eq(3)
          expect(klass.to_json_api.first[:type]).to eq('levels')
          expect(klass.to_json_api.first[:id]).to eq('1')
          expect(klass.to_json_api.last[:type]).to eq('characters')
          expect(klass.to_json_api.first[:id]).to eq('1')
        end
      end

      context 'when resource is a single resource' do
        it 'returns an array of included resources without duplicates' do
          expect(klass.to_json_api.first[:type]).to eq('levels')
          expect(klass.to_json_api.first[:id]).to eq('1')
          expect(klass.to_json_api.last[:type]).to eq('characters')
          expect(klass.to_json_api.first[:id]).to eq('1')
        end
      end
    end

    context 'without includes' do
      let(:includes) { [] }

      context 'when resource is a collection' do
        let(:game) { Game.new(1) }
        let(:resource) { [game, game, Game.new(2)] }

        it 'returns an empty array' do
          expect(klass.to_json_api.count).to eq(0)
        end
      end

      context 'when resource is a single resource' do
        it 'returns an empty array' do
          expect(klass.to_json_api.count).to eq(0)
        end
      end
    end
  end
end
