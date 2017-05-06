module Privacy
  extend ActiveSupport::Concern

  included do
    enum privacy: {
      priv: 0,
      publ: 1
    }
  end
end
