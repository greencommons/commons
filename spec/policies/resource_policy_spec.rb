require 'rails_helper'

describe ResourcePolicy do
  subject { ResourcePolicy.new(user, resource) }

  let(:resource) { FactoryGirl.create(:resource) }

  context 'when guest' do
    let(:user) { nil }

    it { is_expected.to permit_action(:show)    }
  end

  context 'when user' do
    let(:user) { FactoryGirl.create(:user) }

    it { is_expected.to permit_action(:show)    }
  end
end
