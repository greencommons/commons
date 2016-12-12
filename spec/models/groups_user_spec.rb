require 'rails_helper'

RSpec.describe GroupsUser do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      group_user = build(:groups_user)
      expect(group_user).to be_valid
    end

    it 'is created with admin set to false by default' do
      group_user = build(:groups_user)
      expect(group_user.admin).to eq false
    end

    it { is_expected.to validate_presence_of(:group) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:group_id) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:user) }
  end
end
