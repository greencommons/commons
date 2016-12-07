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
        index = double('SearchIndex', add: true)
        allow(SearchIndex).to receive(:new).and_return(index)

        resource = create(:resource)

        expect(SearchIndex).to have_received(:new).
          with(
            model_name: resource.class.name,
            id: resource.id,
            async: true,
          )
        expect(index).to have_received(:add)
      end
    end

    describe 'after_destroy' do
      it 'removes the resource from the search index after deletion' do
        resource = create(:resource)
        index = double('SearchIndex', remove: true)
        allow(SearchIndex).to receive(:new).and_return(index)
        id = resource.id
        model_name = resource.class.name

        resource.destroy

        expect(SearchIndex).to have_received(:new).
          with(
            model_name: model_name,
            id: id,
            async: true,
          )
        expect(index).to have_received(:remove)
      end
    end
  end
end
