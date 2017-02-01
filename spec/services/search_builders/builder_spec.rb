require 'rails_helper'

RSpec.describe SearchBuilders::Builder do
  describe '#search' do
    it 'sends "build" to SearchBuilders::Query and returns itself' do
      expect_any_instance_of(SearchBuilders::Query).to receive(:build)
      builder = SearchBuilders::Builder.new('test', {})
      expect(builder.search).to eq(builder)
    end
  end

  describe '#filter_by_resource_type' do
    it 'sends "build" to SearchBuilders::ResourceTypeFilter and returns itself' do
      expect_any_instance_of(SearchBuilders::ResourceTypeFilter).to receive(:build)
      builder = SearchBuilders::Builder.new('test', {})
      expect(builder.filter_by_resource_type).to eq(builder)
    end
  end

  describe '#models' do
    it 'sends "build" to SearchBuilders::ModelLister' do
      expect_any_instance_of(SearchBuilders::ModelLister).to receive(:build)
      builder = SearchBuilders::Builder.new('test', {})
      builder.models
    end
  end

  describe '#to_elasticsearch' do
    it 'prepare an array of parameters for Elastic Search' do
      builder = SearchBuilders::Builder.new('test', {})

      expect(builder.to_elasticsearch).to eq([
        builder.send(:base), SearchBuilders::ModelLister::MODEL_TYPE_FILTERS.values
      ])
    end
  end
end
