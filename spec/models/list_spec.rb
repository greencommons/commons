require 'rails_helper'

RSpec.describe List do
  describe 'Validations' do
    it 'is valid with valid attributes' do
      list = create(:list)

      expect(list).to be_valid
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:owner) }
    it { is_expected.to validate_inclusion_of(:owner_type).in_array(%w(User Group)) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to have_and_belong_to_many(:resources) }
  end

  it_behaves_like 'indexable', :list
end
