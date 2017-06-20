require 'rails_helper'

describe NetworkPolicy do
  subject { NetworkPolicy.new(user, network) }

  let(:network) { FactoryGirl.create(:network) }

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

    context 'when not a network member' do
      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }

      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when regular network member' do
      before { network.add_user(user) }

      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }

      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when network admin' do
      before { network.add_admin(user) }

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
