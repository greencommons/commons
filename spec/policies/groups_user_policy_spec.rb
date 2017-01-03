require 'rails_helper'

describe GroupPolicy do
  subject { GroupsUserPolicy.new(user, group_user) }

  let(:group) { create(:group) }

  context 'when guest' do
    let(:user) { nil }
    let(:group_user) { group.groups_users.new(user: user) }

    it { is_expected.to forbid_action(:join)   }
    it { is_expected.to forbid_action(:leave)  }
  end

  context 'when user' do
    let(:user) { create(:user) }

    context 'when not a group member' do
      let(:group_user) { group.groups_users.new(user: user) }

      it { is_expected.to permit_action(:join)   }
      it { is_expected.to forbid_action(:leave)  }
    end

    context 'when regular group member' do
      let(:group_user) { group.groups_users.create(user: user) }

      it { is_expected.to forbid_action(:join)   }
      it { is_expected.to permit_action(:leave)  }
    end

    context 'when group admin' do
      let(:group_user) { group.groups_users.create(user: user, admin: true) }

      it { is_expected.to forbid_action(:join)   }
      it { is_expected.to permit_action(:leave)  }
    end
  end
end
