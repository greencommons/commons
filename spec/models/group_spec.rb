require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { FactoryGirl.build(:group) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
    it 'is invalid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end
  describe "Associations" do
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:lists) }
  end
end
