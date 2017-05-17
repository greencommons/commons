module TypesHelper
  def list_owner(owner)
    name = if owner.is_a?(Group)
             "#{owner.name} (Group)"
           else
             "#{owner.first_name} #{owner.last_name}, #{owner.email} (User)"
           end

    { id: "#{owner.class}:#{owner.id}", name: name }
  end
end
