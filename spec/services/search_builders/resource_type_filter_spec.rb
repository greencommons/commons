require 'rails_helper'

RSpec.describe SearchBuilders::ResourceTypeFilter do
  describe '#build' do
    context 'with filters = nil' do
      it 'returns the given es params' do
        filter = SearchBuilders::ResourceTypeFilter.new(nil, something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = {}' do
      it 'returns the given es params' do
        filter = SearchBuilders::ResourceTypeFilter.new({}, something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { resource_types: {} }' do
      it 'returns the given es params' do
        filter = SearchBuilders::ResourceTypeFilter.new({ resource_types: {} },
                                                        something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { resource_types: "" }' do
      it 'returns the given es params' do
        filter = SearchBuilders::ResourceTypeFilter.new({ resource_types: '' },
                                                        something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { resource_types: { books: "on", articles: "on" } }' do
      it 'builds the es params with the right conditions' do
        es_params = SearchBuilders::Builder.new.es_params

        filter = SearchBuilders::ResourceTypeFilter.new(
          {
            resource_types: { books: 'on', articles: 'on' }
          },
          es_params
        )

        expect(filter.build[:query][:bool][:filter][:bool]).to eq(
          should: {
            bool: {
              minimum_should_match: 1,
              should: [
                { bool: { must_not: { exists: { field: 'resource_type' } } } },
                { terms: { resource_type: %w(book article) } }
              ]
            }
          }
        )
      end
    end

    context 'with filters = { resource_types: "books,articles" } }' do
      it 'builds the es params with the right conditions' do
        es_params = SearchBuilders::Builder.new.es_params

        filter = SearchBuilders::ResourceTypeFilter.new(
          {
            resource_types: 'books,articles'
          },
          es_params
        )

        expect(filter.build[:query][:bool][:filter][:bool]).to eq(
          should: {
            bool: {
              minimum_should_match: 1,
              should: [
                { bool: { must_not: { exists: { field: 'resource_type' } } } },
                { terms: { resource_type: %w(book article) } }
              ]
            }
          }
        )
      end
    end
  end
end
