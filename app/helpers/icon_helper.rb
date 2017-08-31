module IconHelper
  def resource_icon(resource)
    if resource.resource_type.to_sym.in?(Resource::RESOURCE_TYPES.keys)
      render "shared/icons/#{resource.resource_type}"
    else
      render 'shared/icons/unknown'
    end
  end
end
