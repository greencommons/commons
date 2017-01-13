require 'rails_helper'

RSpec.describe List do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      list = create(:list)

      expect(list).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:owner) }
    it { is_expected.to validate_inclusion_of(:owner_type).in_array(%w(User Group)) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to have_and_belong_to_many(:resources) }
  end

  describe 'Callbacks' do
    describe 'after_save' do
      it 'adds the list to the search index after creation' do
        allow(AddToIndexJob).to receive(:perform_async)

        list = create(:list)

        expect(AddToIndexJob).to have_received(:perform_async).
          with(list.class.name, list.id)
      end
    end

    describe 'after_destroy' do
      it 'removes the list from the search index after deletion' do
        list = create(:list)
        allow(RemoveFromIndexJob).to receive(:perform_async)

        list.destroy

        expect(RemoveFromIndexJob).to have_received(:perform_async).
          with(list.class.name, list.id)
      end
    end
  end

  it_behaves_like 'indexable', :list
end
