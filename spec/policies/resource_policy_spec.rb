# frozen_string_literal: true
require "rails_helper"

describe ResourcePolicy do
  subject { ResourcePolicy.new(user, resource) }

  let(:resource) { FactoryGirl.create(:resource) }

  context "when guest" do
    let(:user) { nil }

    it { is_expected.to permit_action(:show) }

    it { is_expected.to forbid_action(:index)   }
    it { is_expected.to forbid_action(:new)     }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:destroy) }
  end

  context "when user" do
    let(:user) { FactoryGirl.create(:user) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:new)     }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:destroy) }

    context "when owner" do
      let(:resource) { FactoryGirl.create(:resource, user: user) }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:new)     }
      it { is_expected.to permit_action(:create)  }
      it { is_expected.to permit_action(:update)  }
      it { is_expected.to permit_action(:edit)    }
      it { is_expected.to permit_action(:destroy) }
    end
  end
end
