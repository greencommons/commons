require 'rails_helper'

RSpec.describe Resource, type: :model do
  subject { FactoryGirl.build(:resource) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
    it 'is invalid without a title' do
      subject.title = nil
      expect(subject).to_not be_valid
    end
    it 'is invalid without a resource_type' do
      subject.resource_type = nil
      expect(subject).to_not be_valid
    end

    it 'is invalid with undefined resource_type' do
      expect { subject.resource_type = :nonsense }.to raise_error ArgumentError
    end
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end
end
