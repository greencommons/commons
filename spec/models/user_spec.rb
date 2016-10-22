require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build(:user) }
  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a password' do
      subject.password = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it { should have_and_belong_to_many(:groups) }
    it { should have_many(:lists) }
  end
end
