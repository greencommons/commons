require 'rails_helper'

RSpec.describe SearchBuilders::Sorter do
  def sort_array(param, dir)
    [
      { param => { order: dir } },
      '_score'
    ]
  end

  let(:es_params) { SearchBuilders::Builder.new.es_params }
  let(:filter) { SearchBuilders::Sorter.new(param, es_params) }

  describe '#build' do
    context 'with sort = nil and dir = nil' do
      it 'returns the given es params' do
        filter = SearchBuilders::Sorter.new(nil, something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    context 'sort by score' do
      it 'returns the given es params' do
        filter = SearchBuilders::Sorter.new('score', something: 'else')
        expect(filter.build).to eq(something: 'else')
      end
    end

    describe 'sort by published_at' do
      context 'asc' do
        let(:param) { 'published_at' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(sort_array('published_at', 'asc'))
        end
      end

      context 'desc' do
        let(:param) { '-published_at' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(sort_array('published_at', 'desc'))
        end
      end
    end

    describe 'sort by created_at' do
      context 'asc' do
        let(:param) { 'created_at' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(sort_array('created_at', 'asc'))
        end
      end

      context 'desc' do
        let(:param) { '-created_at' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(sort_array('created_at', 'desc'))
        end
      end
    end

    describe 'sort by updated_at' do
      context 'asc' do
        let(:param) { 'updated_at' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(sort_array('updated_at', 'asc'))
        end
      end

      context 'desc' do
        let(:param) { '-updated_at' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(sort_array('updated_at', 'desc'))
        end
      end
    end

    describe 'sort by fake' do
      context 'asc' do
        let(:param) { 'fake' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(['_score'])
        end
      end

      context 'desc' do
        let(:param) { '-fake' }

        it 'builds the es params with the right conditions' do
          expect(filter.build[:sort]).to eq(['_score'])
        end
      end
    end
  end
end
