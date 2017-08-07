module V1
  class NetworksUserPresenter < Yumi::Base
    type 'users'
    attributes :email, :first_name, :last_name, :admin, :created_at, :updated_at
    links :self
    belongs_to :network

    delegate :email, :first_name, :last_name, to: :'object.user'

    def resource_id(o = object)
      o.user.id
    end
  end
end
