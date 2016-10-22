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

  describe '#resources' do
    let(:r1) { FactoryGirl.create(:resource) }
    let(:r2) { FactoryGirl.create(:resource) }
    let(:l1) { FactoryGirl.create(:list, resources: [r1,r2]) }
    let(:l2) { FactoryGirl.create(:list, resources: [r2]) }

    it 'returns a unique list of resources' do
      subject.update(lists: [l1, l2])
      expect(subject.resources).to eq([r1,r2]) 
    end
  end

  describe "Associations" do
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:lists) }
  end
end
