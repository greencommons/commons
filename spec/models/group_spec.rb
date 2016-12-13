require 'rails_helper'

RSpec.describe Group do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      group = create(:group)

      expect(group).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#resources' do
    let(:r1) { create(:resource) }
    let(:r2) { create(:resource) }
    let(:l1) { create(:list, resources: [r1, r2]) }
    let(:l2) { create(:list, resources: [r2]) }

    it 'returns a unique list of resources' do
      group = create(:group)

      group.update(lists: [l1, l2])

      expect(group.resources).to eq([r1, r2])
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:groups_users) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:lists) }
  end
end
