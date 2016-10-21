require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes'
    it 'is not valid without an email'
    it 'is not valid without a password'
  end
end
