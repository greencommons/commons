module V1
  class UserPresenter < Yumi::Base
    type 'user'
    attributes :id
    links :self
  end
end
