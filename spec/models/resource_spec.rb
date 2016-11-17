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
    it { is_expected.to have_and_belong_to_many(:lists) }
  end

  describe 'Callbacks' do
    describe 'after_save' do
      it 'adds the resource to the search index after creation' do
        allow(SearchIndex).to receive(:add)

        resource = create(:resource)

        expect(SearchIndex).to have_received(:add).with(resource)
      end
    end

    describe 'after_destroy' do
      it 'removes the resource from the search index after deletion' do
        allow(SearchIndex).to receive(:remove)

        resource = create(:resource)
        resource.destroy

        expect(SearchIndex).to have_received(:remove).with(resource)
      end
    end
  end
end
