require 'rails_helper'

describe ListPolicy do
  subject { ListPolicy.new(user, list) }

  let(:list) { FactoryGirl.create(:list) }

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

    context 'when not the list owner' do
      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }

      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'when list owner' do
      before do
        list.owner = user
        list.save
      end

      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:new)     }
      it { is_expected.to permit_action(:update)  }
      it { is_expected.to permit_action(:edit)    }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'when list is owned by a group where the user is a member' do
      before do
        group = create(:group)
        group.add_user(user)
        list.owner = group
        list.save
      end

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
