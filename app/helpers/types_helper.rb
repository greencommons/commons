module TypesHelper
  def list_options(user)
    suggestions = current_user.groups.order('groups_users.created_at DESC').limit(5).to_a
    suggestions.unshift(user)
    suggestions.map do |suggestion|
      {
        id: "#{suggestion.class}:#{suggestion.id}",
        name: owner_name(suggestion)
      }
    end
  end

  def owner_options(user, resource)
    user.all_owned_lists.where.not(id: resource.lists.pluck(:id)).limit(5).map do |l|
      { id: l.id, name: l.name }
    end
  end

  private

  def owner_name(suggestion)
    if suggestion.is_a?(Group)
      "#{suggestion.name} (Group)"
    else
      "#{suggestion.first_name} #{suggestion.last_name}, #{suggestion.email} (User)"
    end
  end

  def user_lists(user, resource)
    user.all_owned_lists.where.not(id: resource.lists.pluck(:id)).limit(5).map do |l|
      { id: l.id, name: l.name }
    end
  end
end
