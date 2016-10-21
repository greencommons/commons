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
  end

  describe "Associations" do
    it { should belong_to(:user) }
  end
end
