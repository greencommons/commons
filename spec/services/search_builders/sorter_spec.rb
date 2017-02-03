require 'rails_helper'

RSpec.describe SearchBuilders::Sorter do
  describe '#build' do
    context 'with sort = nil and dir = nil' do
      it 'returns the given es params' do
        filter = SearchBuilders::Sorter.new(nil, something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with sort = score' do
      it 'returns the given es params' do
        filter = SearchBuilders::Sorter.new('score', something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'with sort = recent' do
      it 'builds the es params with the right conditions' do
        es_params = SearchBuilders::Builder.new.es_params
        filter = SearchBuilders::Sorter.new('recent', es_params)

        expect(filter.build[:sort]).to eq([
                                            { created_at: { order: :desc } },
                                            '_score'
                                          ])
      end
    end

    context 'with sort = oldest' do
      it 'builds the es params with the right conditions' do
        es_params = SearchBuilders::Builder.new.es_params
        filter = SearchBuilders::Sorter.new('oldest', es_params)

        expect(filter.build[:sort]).to eq([
                                            { created_at: { order: :asc } },
                                            '_score'
                                          ])
      end
    end
  end
end
