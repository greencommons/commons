require 'spec_helper'
require_relative './support/classes'

describe Yumi::Base do
  let(:url) { BASE_URL }
  let(:resource) { Game.new(1) }
  let(:resources) { [Game.new(1), Game.new(2)] }
  let(:meta) { { some: 'stuff' } }

  describe '#initialize' do
    it 'sets the instance variable' do
    end
  end

  describe '#as_relationship' do
    it 'generates the relationship hash' do
      expect(Fake::GamePresenter.new(url, resources, Fake).as_relationship).to eq(
        data: [{ type: 'games', id: '1' }, { type: 'games', id: '2' }],
        links: {
          self: "#{url}/relationships/games"
        }
      )
    end

    context 'with a prefix' do
      it 'generates the relationship hash' do
        presenter = Fake::GamePresenter.new(url, resources, Fake, 'cool_prefix/')
        expect(presenter.as_relationship).to eq(
          data: [{ type: 'games', id: '1' }, { type: 'games', id: '2' }],
          links: {
            self: "#{url}/cool_prefix/relationships/games"
          }
        )
      end
    end
  end

  describe '#as_included' do
    it 'generates the included hash' do
      expect(Fake::GamePresenter.new(url, resource, Fake).as_included).to eq(
        type: 'games',
        id: '1',
        attributes: {
          title: 'Super Game',
          rating: '10'
        },
        links: {
          self: "#{url}/games/1"
        }
      )
    end
  end
end
