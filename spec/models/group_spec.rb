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

  describe '#add_admin' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    it 'adds the user as an admin' do
      group.add_admin(user)

      group_user = group.groups_users.where(user: user).first
      expect(group_user).not_to be nil
      expect(group_user.admin).to eq(true)
    end
  end

  describe '#add_user' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    it 'adds the user as a regular user' do
      group.add_user(user)

      group_user = group.groups_users.where(user: user).first
      expect(group_user).not_to be nil
      expect(group_user.admin).to eq(false)
    end
  end

  describe '#admin?' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    context 'with admin' do
      it 'gets true back' do
        group.add_admin(user)
        expect(group.admin?(user)).to be true
      end
    end

    context 'with regular user' do
      it 'gets false back' do
        group.add_user(user)
        expect(group.admin?(user)).to be false
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:groups_users) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:lists) }
  end
end
