require 'rails_helper'

RSpec.describe Resource do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      resource = build(:resource)

      expect(resource).to be_valid
    end

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:resource_type) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:lists_items) }
  end

  it_behaves_like 'indexable', :resource

  describe 'privacy' do
    let(:resource) { create(:resource, privacy: :priv) }

    describe 'after_commit on: [:create]' do
      it "does not add the #{name} to the search index after creation" do
        allow(AddToIndexJob).to receive(:perform_async)

        expect(AddToIndexJob).not_to have_received(:perform_async).
          with(resource.class.name, resource.id)
      end
    end

    describe 'after_commit on: [:update]' do
      it "does not update the #{name} index in the search index after update" do
        allow(UpdateIndexJob).to receive(:perform_async)

        resource.touch

        expect(UpdateIndexJob).not_to have_received(:perform_async).
          with(resource.class.name, resource.id, [])
      end
    end

    describe 'after_commit on: [:destroy]' do
      it "does not remove the #{name} from the search index after deletion" do
        allow(RemoveFromIndexJob).to receive(:perform_async)

        resource.destroy

        expect(RemoveFromIndexJob).not_to have_received(:perform_async).
          with(resource.class.name, resource.id)
      end
    end
  end
end
