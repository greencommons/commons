require 'rails_helper'

RSpec.describe SearchBuilders::ResourceTypeFilter do
  describe '#build' do
    context 'with filters = nil' do
      it 'returns the given search params' do
        filter = SearchBuilders::ResourceTypeFilter.new(nil, { something: 'else' })
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = {}' do
      it 'returns the given search params' do
        filter = SearchBuilders::ResourceTypeFilter.new({}, { something: 'else' })
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { resource_types: {} }' do
      it 'returns the given search params' do
        filter = SearchBuilders::ResourceTypeFilter.new({ resource_types: {} },
                                                        { something: 'else' })
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { resource_types: { books: "on", articles: "on" } }' do
      it 'builds the search params with the right conditions' do
        search_params = SearchBuilders::Builder.new({}, {}).search_params

        filter = SearchBuilders::ResourceTypeFilter.new({
          resource_types: { books: 'on', articles: 'on' }
        }, search_params)

        expect(filter.build).to eq(
          {
            query: {
              bool: {
                must: {
                  bool: {
                    should: []
                  }
                },
                filter: {
                  bool: {
                    should: {
                      bool: {
                        minimum_should_match: 1,
                        should: [
                          { bool: { must_not: { exists: { field: 'resource_type' } } } },
                          { term: { resource_type: 'book' } },
                          { term: { resource_type: 'article' } }
                        ]
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
