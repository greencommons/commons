module IconHelper
  def resource_icon(resource)
    if resource.resource_type.in?(%w(article book report))
      render "shared/icons/#{resource.resource_type}"
    else
      render 'shared/icons/unknown'
    end
  end
end
