require 'rails_helper'

RSpec.describe SearchBuilders::DateFilter do
  describe '#build' do
    context 'with filters = nil' do
      it 'returns the given es params' do
        filter = SearchBuilders::DateFilter.new(nil, something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = {}' do
      it 'returns the given es params' do
        filter = SearchBuilders::DateFilter.new({}, something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { start: nil, end: nil }' do
      it 'returns the given es params' do
        filter = SearchBuilders::DateFilter.new({ start: nil, end: nil },
                                                something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { start: "", end: "" }' do
      it 'returns the given es params' do
        filter = SearchBuilders::DateFilter.new({ start: '', end: '' },
                                                something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with filters = { start: "1483657200", end: "1483829999" }' do
      it 'builds the es params with the right conditions' do
        es_params = SearchBuilders::Builder.new.es_params

        filter = SearchBuilders::DateFilter.new(
          {
            start: '1483657200', end: '1483829999'
          },
          es_params
        )

        expect(filter.build[:query][:bool][:filter][:bool]).to eq(
          should: {
            bool: {
              minimum_should_match: 1,
              should: [
                {
                  range: {
                    published_at: {
                      lte: '2017-01-07T23:59:59',
                      gte: '2017-01-06T00:00:00'
                    }
                  }
                }
              ]
            }
          }
        )
      end
    end
  end
end
