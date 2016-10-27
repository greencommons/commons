require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      user = FactoryGirl.build(:user)

      expect(user).to be_valid
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe 'Associations' do
    it { is_expected.to have_and_belong_to_many(:groups) }
    it { is_expected.to have_many(:lists) }
  end
end
