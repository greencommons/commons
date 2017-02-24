require 'rails_helper'

RSpec.describe Resource do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      resource = build(:resource)

      expect(resource).to be_valid
    end

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:resource_type) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_and_belong_to_many(:lists) }
  end

  it_behaves_like 'indexable', :resource
end
