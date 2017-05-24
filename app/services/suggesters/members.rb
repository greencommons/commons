module Suggesters
  class Members
    def initialize(query:, group_id: nil)
      @query = query
      @group_id = group_id
    end

    def suggest
      users - group_members
    end

    private

    def users
      @users ||= User.filter_by_email(@query).sort_by_email.limit(10)
    end

    def group_members
      return [] unless @group_id
      @group_members ||= User.joins(:groups_users).where('group_id = ?', @group_id)
    end
  end
end
