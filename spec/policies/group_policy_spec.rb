require 'rails_helper'

describe GroupPolicy do
  subject { GroupPolicy.new(user, group) }

  let(:group) { FactoryGirl.create(:group) }

  context 'when guest' do
    let(:user) { nil }

    it { is_expected.to permit_action(:show)    }

    it { is_expected.to forbid_action(:index)   }
    it { is_expected.to forbid_action(:new)     }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'when user' do
    let(:user) { FactoryGirl.create(:user) }

    context 'when not a group member' do
      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }

      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when regular group member' do
      before { group.add_user(user) }

      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }

      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when group admin' do
      before { group.add_admin(user) }

      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }
      it { is_expected.to permit_action(:update)  }
      it { is_expected.to permit_action(:edit)    }
      it { is_expected.to permit_action(:destroy) }
    end
  end
end
