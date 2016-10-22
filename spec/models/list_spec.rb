require 'rails_helper'

RSpec.describe List, type: :model do
  subject { FactoryGirl.create(:list) }

  describe 'Validations' do
    subject { FactoryGirl.build(:list) }
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is invalid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid without an owner' do
      subject.owner = nil
      expect(subject).to_not be_valid
    end

    it 'is valid with a user owner' do
      subject.owner = FactoryGirl.create(:user)
      subject.save
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
    it 'returns a user if it the owner is a user' do
      subject.update(owner: FactoryGirl.create(:user))
      expect(subject.owner).to be_a(User)
    end
    it 'returns a gorup if the owner is a group' do
      subject.update(owner: FactoryGirl.create(:group))
      expect(subject.owner).to be_a(Group)
    end
  end

  describe "Associations" do
    it { should belong_to(:owner) }
    it { should have_and_belong_to_many(:resources) }
  end
end
