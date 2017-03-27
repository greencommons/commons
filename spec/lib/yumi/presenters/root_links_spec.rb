require 'spec_helper'
require_relative '../support/classes'

describe Yumi::Presenters::RootLinks do
  let(:url) { "#{BASE_URL}/api/v1/games" }
  let(:params) { {} }
  let(:total) { nil }
  let(:klass) { Yumi::Presenters::RootLinks.new(url, params, total, collection) }

  describe '#to_json_api' do
    context 'when collection' do
      let(:collection) { true }
      let(:resource) { [Game.new(1), Game.new(2), Game.new(3)] }

      it 'returns /games with default page and per' do
        expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games?page=1&per=10",
                                        first: "#{BASE_URL}/api/v1/games?page=1&per=10")
      end

      describe 'pagination' do
        context 'first page' do
          let(:params) { { page: 1, per: 100 } }
          let(:total) { 200 }

          it 'returns /games?page=1&per=100' do
            expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games?page=1&per=100",
                                            first: "#{BASE_URL}/api/v1/games?page=1&per=100",
                                            last: "#{BASE_URL}/api/v1/games?page=2&per=100",
                                            next: "#{BASE_URL}/api/v1/games?page=2&per=100")
          end
        end

        context 'second page' do
          let(:params) { { page: 2, per: 50 } }
          let(:total) { 200 }

          it 'returns /games?page=2&per=100' do
            expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games?page=2&per=50",
                                            first: "#{BASE_URL}/api/v1/games?page=1&per=50",
                                            prev: "#{BASE_URL}/api/v1/games?page=1&per=50",
                                            last: "#{BASE_URL}/api/v1/games?page=4&per=50",
                                            next: "#{BASE_URL}/api/v1/games?page=3&per=50")
          end
        end

        context 'last page' do
          let(:params) { { page: 2, per: 100 } }
          let(:total) { 200 }

          it 'returns /games?page=2&per=100' do
            expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games?page=2&per=100",
                                            first: "#{BASE_URL}/api/v1/games?page=1&per=100",
                                            prev: "#{BASE_URL}/api/v1/games?page=1&per=100",
                                            last: "#{BASE_URL}/api/v1/games?page=2&per=100")
          end
        end
      end
    end

    context 'when single resource' do
      let(:url) { "#{BASE_URL}/api/v1/games/1" }
      let(:collection) { false }
      let(:resource) { [Game.new(1), Game.new(2), Game.new(3)] }

      it 'returns /games/1' do
        expect(klass.to_json_api).to eq(self: "#{BASE_URL}/api/v1/games/1")
      end
    end
  end
end
