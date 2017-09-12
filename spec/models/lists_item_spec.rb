require 'rails_helper'

RSpec.describe ListsItem do
  describe 'Validations' do
    let(:resource) { create(:lists_item, item: item, list: list) }
    let(:item) { create(:resource) }
    let(:list) { create(:list) }
    let(:uniqueness_error_message) do
      "List \"#{item.name}\" is already in the \"#{list.name}\" list."
    end

    it 'is valid with valid attributes' do
      expect(resource).to be_valid
    end

    it { is_expected.to validate_presence_of(:list) }
    it { is_expected.to validate_presence_of(:item) }

    it 'shuould validate uniqueness' do
      cloned_resource = resource.dup
      expect(cloned_resource.valid?).to eq(false)
      expect(cloned_resource.errors.full_messages.to_sentence).to eq(uniqueness_error_message)
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to belong_to(:item) }
  end
end
