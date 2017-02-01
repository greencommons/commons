require 'rails_helper'

RSpec.describe SearchBuilders::Query do
  describe '#build' do
    context 'with query = nil' do
      it 'returns the given search query' do
        query = SearchBuilders::Query.new(nil, something: 'else')
        expect(query.build).to eq(something: 'else')
      end
    end

    context 'with query = ""' do
      it 'returns the given search query' do
        query = SearchBuilders::Query.new('', something: 'else')
        expect(query.build).to eq(something: 'else')
      end
    end

    context 'with query = "test"' do
      it 'builds the es params with the right conditions' do
        es_params = SearchBuilders::Builder.new.es_params
        query = SearchBuilders::Query.new('test', es_params)

        expect(query.build[:query][:bool][:filter]).to eq(
          bool: { should: { bool: { minimum_should_match: 1, should: [] } } }
        )
      end
    end
  end
end
