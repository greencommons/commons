require 'rails_helper'

RSpec.describe ProcessResourceFileJob do
  describe '#perform' do
    let(:resource) { create(:resource) }
    let(:worker) { ProcessResourceFileJob.new }
    let(:perform) { worker.perform(resource_id) }

    context 'when the resource is not found' do
      let(:resource_id) { -123 }

      it 'raises an error' do
        expect { perform }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the resource is found' do
      let(:resource_id) { resource.id }

      it 'process the resource' do
        expect_any_instance_of(Resources::FileProcessor).to receive(:call)
        perform
      end
    end
  end
end
