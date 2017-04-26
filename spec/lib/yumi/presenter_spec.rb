require 'spec_helper'
require_relative './support/classes'

describe Yumi::Presenter do
  let(:url) { "#{BASE_URL}/api/v1" }
  let(:resource) { Game.new(1) }
  let(:resources) { [Game.new(1), Game.new(2)] }
  let(:meta) { { some: 'stuff' } }

  let(:presenter_with_resources) do
    Yumi::Presenter.new(url: url,
                        current_url: "#{url}/games",
                        resource: resources,
                        params: { include: 'levels,characters' },
                        presenters_module: Fake,
                        meta: meta)
  end

  let(:presenter_with_resource) do
    Yumi::Presenter.new(url: url,
                        current_url: "#{url}/games/#{resource.id}",
                        resource: resource,
                        params: { include: 'levels,characters' },
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
        expect(presenter_with_resources.as_json_api[:links]).to eq(
          self: 'http://example.org:80/api/v1/games?include=levels,characters&page=1&per=10',
          first: 'http://example.org:80/api/v1/games?include=levels,characters&page=1&per=10'
        )
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
        expect(presenter_with_resource.as_json_api[:links]).to eq(
          self: 'http://example.org:80/api/v1/games/1?include=levels,characters'
        )
      end

      it 'correctly generates the data section' do
        expect(presenter_with_resource.as_json_api[:data]).to eq(game1)
      end

      it 'correctly generates the included section' do
        expect(presenter_with_resource.as_json_api[:included]).to eq(included)
      end
    end
  end
end
