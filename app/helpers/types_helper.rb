module TypesHelper
  def list_owner(owner)
    name = if owner.is_a?(Group)
             "#{owner.name} (Group)"
           else
             "#{owner.first_name} #{owner.last_name}, #{owner.email} (User)"
           end

    { id: "#{owner.class}:#{owner.id}", name: name }
  end

  def user_lists(user, resource)
    user.owned_lists.where.not(id: resource.lists.pluck(:id)).limit(5).map do |l|
      { id: l.id, name: l.name }
    end
  end
end
