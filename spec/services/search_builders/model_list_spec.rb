require 'rails_helper'

RSpec.describe SearchBuilders::ModelLister do
  describe '#build' do
    context 'with filters = nil' do
      it 'returns all the supported model types' do
        lister = SearchBuilders::ModelLister.new(nil)
        expect(lister.build).to eq [Resource, List, Group]
      end
    end

    context 'with filters = {}' do
      it 'returns all the supported model types' do
        lister = SearchBuilders::ModelLister.new({})
        expect(lister.build).to eq [Resource, List, Group]
      end
    end

    context 'with filters = { model_types: "" }' do
      it 'returns only the requested types Resource and List' do
        lister = SearchBuilders::ModelLister.new(model_types: '')
        expect(lister.build).to eq [Resource, List, Group]
      end
    end

    context 'with filters = { model_types: {} }' do
      it 'returns all the supported model types' do
        lister = SearchBuilders::ModelLister.new(model_types: {})
        expect(lister.build).to eq [Resource, List, Group]
      end
    end

    context 'with filters = { model_types: { resources: "on", lists: "on" } }' do
      it 'returns only the requested types Resource and List' do
        lister = SearchBuilders::ModelLister.new(model_types: { resources: 'on', lists: 'on' })
        expect(lister.build).to eq [Resource, List]
      end
    end

    context 'with filters = { model_types: "resources,lists" }' do
      it 'returns only the requested types Resource and List' do
        lister = SearchBuilders::ModelLister.new(model_types: 'resources,lists')
        expect(lister.build).to eq [Resource, List]
      end
    end
  end
end
