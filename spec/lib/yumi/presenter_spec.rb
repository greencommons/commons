require 'spec_helper'

describe Yumi::Presenter do
  class Game
    attr_accessor :id, :title, :rating,
                  :levels, :characters

    def initialize(id)
      @id = id
      @title = 'Super Game'
      @rating = '10'
      @levels = [Level.new('1', 10), Level.new('2', 20)]
      @characters = [Character.new('1')]
    end
  end

  class Level
    attr_accessor :id, :title, :number

    def initialize(id, _number)
      @id = id
      @title = 'Super Level'
      @number = id
    end
  end

  class Character
    attr_accessor :id, :name, :level_number

    def initialize(id)
      @id = id
      @name = 'John Doe'
      @level_number = 1
    end
  end

  module Fake
    class GamePresenter < ::Yumi::Base
      type 'game'
      attributes :title, :rating
      has_many :levels, :characters
      links :self
    end

    class LevelPresenter < ::Yumi::Base
      type 'level'
      attributes :title, :number
      links :self
    end

    class CharacterPresenter < ::Yumi::Base
      type 'character'
      attributes :name, :level_number
      links :self
    end
  end

  let(:url) { "#{BASE_URL}/api/v1" }
  let(:resource) { Game.new(1) }
  let(:resources) { [Game.new(1), Game.new(2)] }
  let(:meta) { { some: 'stuff' } }

  let(:presenter_with_resources) do
    Yumi::Presenter.new(url: url,
                        current_url: "#{url}/games",
                        resource: resources,
                        presenters_module: Fake,
                        meta: meta)
  end

  let(:presenter_with_resource) do
    Yumi::Presenter.new(url: url,
                        current_url: url,
                        resource: resource,
                        presenters_module: Fake,
                        meta: meta)
  end

  describe '#as_json_api' do
    let(:game1) do
      {
        type: 'games',
        id: '1',
        attributes: {
          title: 'Super Game',
          rating: '10'
        },
        links: { self: 'http://example.org:80/api/v1/games/1' },
        relationships: {
          levels: {
            data: [{ type: 'levels', id: '1' }, { type: 'levels', id: '2' }],
            links: {
              self: 'http://example.org:80/api/v1/games/1/relationships/levels',
              related: 'http://example.org:80/api/v1/games/1/levels'
            }
          },
          characters: {
            data: [{ type: 'characters', id: '1' }],
            links: {
              self: 'http://example.org:80/api/v1/games/1/relationships/characters',
              related: 'http://example.org:80/api/v1/games/1/characters'
            }
          }
        }
      }
    end
    let(:game2) do
      {
        type: 'games',
        id: '2',
        attributes: {
          title: 'Super Game',
          rating: '10'
        },
        links: { self: 'http://example.org:80/api/v1/games/2' },
        relationships: {
          levels: {
            data: [{ type: 'levels', id: '1' }, { type: 'levels', id: '2' }],
            links: {
              self: 'http://example.org:80/api/v1/games/2/relationships/levels',
              related: 'http://example.org:80/api/v1/games/2/levels'
            }
          },
          characters: {
            data: [{ type: 'characters', id: '1' }],
            links: {
              self: 'http://example.org:80/api/v1/games/2/relationships/characters',
              related: 'http://example.org:80/api/v1/games/2/characters'
            }
          }
        }
      }
    end
    let(:included) do
      [
        {
          type: 'levels',
          id: '1',
          attributes: { title: 'Super Level', number: '1' },
          links: { self: 'http://example.org:80/api/v1/levels/1' }
        },
        {
          type: 'levels',
          id: '2',
          attributes: { title: 'Super Level', number: '2' },
          links: { self: 'http://example.org:80/api/v1/levels/2' }
        },
        {
          type: 'characters',
          id: '1',
          attributes: { name: 'John Doe', level_number: 1 },
          links: { self: 'http://example.org:80/api/v1/characters/1' }
        }
      ]
    end

    context 'when resource is a collection' do
      it 'correctly generates the meta section' do
        expect(presenter_with_resources.as_json_api[:meta]).to eq(meta)
      end

      it 'correctly generates the links section' do
        expect(presenter_with_resources.as_json_api[:links]).to eq(self: 'http://example.org:80/api/v1/games',
                                                                   next: '',
                                                                   last: '')
      end

      it 'correctly generates the data section' do
        expect(presenter_with_resources.as_json_api[:data]).to eq([game1, game2])
      end

      it 'correctly generates the included section' do
        expect(presenter_with_resources.as_json_api[:included]).to eq(included)
      end
    end

    context 'when resource is a single resource' do
      it 'correctly generates the meta section' do
        expect(presenter_with_resource.as_json_api[:meta]).to eq(meta)
      end

      it 'correctly generates the links section' do
        expect(presenter_with_resource.as_json_api[:links]).to eq(self: 'http://example.org:80/api/v1/games/1')
      end

      it 'correctly generates the data section' do
        expect(presenter_with_resource.as_json_api[:data]).to eq(game1)
      end

      it 'correctly generates the included section' do
        expect(presenter_with_resource.as_json_api[:included]).to eq(included)
      end
    end
  end

  describe '#as_relationship' do
    it 'generates the relationship hash' do
      expect(presenter_with_resources.as_relationship).to eq(data: [{ type: 'games', id: '1' }, { type: 'games', id: '2' }],
                                                             links: {
                                                               self: "#{url}/relationships/games",
                                                               related: "#{url}/games"
                                                             })
    end
  end

  describe '#as_included' do
    it 'generates the included hash' do
      expect(presenter_with_resource.as_included).to eq(type: 'games',
                                                        id: '1',
                                                        attributes: {
                                                          title: 'Super Game',
                                                          rating: '10'
                                                        },
                                                        links: {
                                                          self: "#{url}/games/1"
                                                        })
    end
  end
end
