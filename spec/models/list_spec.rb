require 'rails_helper'

RSpec.describe List, type: :model do
  subject { FactoryGirl.build(:list) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without an owner' do
      subject.owner = nil
      expect(subject).to_not be_valid
    end

    it 'is valid with a user owner' do
      subject.owner = FactoryGirl.create(:user)
      expect(subject).to be_valid
    end

    it 'is valid with a group owner' do
      subject.owner = FactoryGirl.create(:group)
      expect(subject).to be_valid
    end

    it 'is invalid with a non-user or non-group owner' do
      subject.owner = FactoryGirl.create(:resource)
      expect(subject).to_not be_valid
    end
  end

  describe '#owner' do
    it 'returns a user if it the owner is a user'
    it 'returns a gorup if the owner is a group'
  end

  describe "Associations" do
    it { should belong_to(:owner) }
    it { should have_and_belong_to_many(:resources) }
  end
end
