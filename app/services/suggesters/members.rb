module Suggesters
  class Members
    def initialize(query:, network_id: nil)
      @query = query
      @network_id = network_id
    end

    def suggest
      users - network_members
    end

    private

    def users
      @users ||= User.filter_by_email(@query).sort_by_email.limit(10)
    end

    def network_members
      return [] unless @network_id
      @network_members ||= User.joins(:networks_users).where('network_id = ?', @network_id)
    end
  end
end
