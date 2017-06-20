require 'rails_helper'

describe NetworkPolicy do
  subject { NetworksUserPolicy.new(user, network_user) }

  let(:network) { create(:network) }

  context 'when guest' do
    let(:user) { nil }
    let(:network_user) { network.networks_users.new(user: user) }

    it { is_expected.to forbid_action(:join)   }
    it { is_expected.to forbid_action(:leave)  }
  end

  context 'when user' do
    let(:user) { create(:user) }

    context 'when not a network member' do
      let(:network_user) { network.networks_users.new(user: user) }

      it { is_expected.to permit_action(:join)   }
      it { is_expected.to forbid_action(:leave)  }
    end

    context 'when regular network member' do
      let(:network_user) { network.networks_users.create(user: user) }

      it { is_expected.to forbid_action(:join)   }
      it { is_expected.to permit_action(:leave)  }
    end

    context 'when network admin' do
      let(:network_user) { network.networks_users.create(user: user, admin: true) }

      it { is_expected.to forbid_action(:join)   }
      it { is_expected.to permit_action(:leave)  }
    end
  end
end
