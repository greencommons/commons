module V1
  class GroupsUserPresenter < Yumi::Base
    type 'users'
    attributes :email, :first_name, :last_name, :admin, :created_at, :updated_at
    links :self
    belongs_to :group

    delegate :email, :first_name, :last_name, to: :'object.user'
  end
end
