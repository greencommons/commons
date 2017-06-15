require 'rails_helper'

RSpec.describe Network do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      network = create(:network)

      expect(network).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
  end

  describe '#latest_resources' do
    let(:r1) { create(:resource) }
    let(:r2) { create(:resource) }
    let(:l1) { create(:list, resources: [r1, r2]) }
    let(:l2) { create(:list, resources: [r2]) }

    it 'returns a unique list of resources' do
      network = create(:network)

      network.update(lists: [l1, l2])

      expect(network.latest_resources.to_a).to eq([r2, r1])
    end

    it 'returns the number of records specified by limit' do
      network = create(:network)

      network.update(lists: [l1, l2])

      expect(network.latest_resources(limit: 1).to_a).to eq([r2])
    end
  end

  describe '#add_admin' do
    let(:network) { create(:network) }
    let(:user) { create(:user) }

    it 'adds the user as an admin' do
      network.add_admin(user)

      network_user = network.networks_users.where(user: user).first
      expect(network_user).not_to be nil
      expect(network_user.admin).to eq(true)
    end
  end

  describe '#add_user' do
    let(:network) { create(:network) }
    let(:user) { create(:user) }

    it 'adds the user as a regular user' do
      network.add_user(user)

      network_user = network.networks_users.where(user: user).first
      expect(network_user).not_to be nil
      expect(network_user.admin).to eq(false)
    end
  end

  describe '#admin?' do
    let(:network) { create(:network) }
    let(:user) { create(:user) }

    context 'with admin' do
      it 'gets true back' do
        network.add_admin(user)
        expect(network.admin?(user)).to be true
      end
    end

    context 'with regular user' do
      it 'gets false back' do
        network.add_user(user)
        expect(network.admin?(user)).to be false
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:networks_users) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:owned_lists) }
    it { is_expected.to have_many(:lists_items) }
    it { is_expected.to have_many(:lists) }
  end

  it_behaves_like 'indexable', :network
end
