require 'rails_helper'

RSpec.describe User do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = build(:user)

      expect(user).to be_valid
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:bio).is_at_most(500) }
  end

  describe 'Associations' do
    it { is_expected.to have_many(:groups_users) }
    it { is_expected.to have_many(:groups) }
    it { is_expected.to have_many(:owned_lists) }
    it { is_expected.to have_many(:group_owned_lists) }
  end

  describe '#full_name' do
    it 'builds the full_name using first_name and last_name' do
      user = build(:user, first_name: 'John', last_name: 'Wick')
      expect(user.full_name).to eq 'John Wick'
    end
  end

  describe '#all_owned_lists' do
    it 'returns all the lists owned by the user and by groups the user belongs to' do
      user = create(:user)
      group1 = create(:group)
      group2 = create(:group)
      group1.add_user(user)
      group2.add_user(user)
      list1 = create(:list, owner: user)
      list2 = create(:list, owner: group1)
      list3 = create(:list, owner: group2)

      expect(user.all_owned_lists).to match_array([list1, list2, list3])
    end
  end
end
