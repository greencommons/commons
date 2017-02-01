require 'rails_helper'

RSpec.describe SearchBuilders::Query do
  describe '#build' do
    context 'with query = nil' do
      it 'returns the given search query' do
        query = SearchBuilders::Query.new(nil, { something: 'else' })
        expect(query.build).to eq({ something: 'else' })
      end
    end

    context 'with query = ""' do
      it 'returns the given search query' do
        query = SearchBuilders::Query.new('', { something: 'else' })
        expect(query.build).to eq({ something: 'else' })
      end
    end

    context 'with query = "test"' do
      it 'builds the search params with the right conditions' do
        search_params = SearchBuilders::Builder.new({}, {}).search_params
        query = SearchBuilders::Query.new('test', search_params)

        expect(query.build).to eq(
          {
            query: {
              bool: {
                must: {
                  bool: {
                    should: [
                      { match: { title: 'test' } },
                      { match: { name: 'test' } }
                    ]
                  }
                },
                filter: {
                  bool: {
                    should: {
                      bool: {
                        minimum_should_match: 1,
                        should: []
                      }
                    }
                  }
                }
              }
            }
          }
        )
      end
    end
  end
end
