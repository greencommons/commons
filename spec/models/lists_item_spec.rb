require 'rails_helper'

RSpec.describe ListsItem do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      liste_item = build(:lists_item)
      expect(liste_item).to be_valid
    end
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:list) }
    it { is_expected.to belong_to(:item) }
  end
end
