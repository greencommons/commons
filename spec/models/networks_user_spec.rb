require 'rails_helper'

RSpec.describe NetworksUser do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      network_user = build(:networks_user)
      expect(network_user).to be_valid
    end

    it 'is created with admin set to false by default' do
      network_user = build(:networks_user)
      expect(network_user.admin).to eq false
    end

    it { is_expected.to validate_presence_of(:network) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:network_id) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:network) }
    it { is_expected.to belong_to(:user) }
  end
end
