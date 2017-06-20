module LinkHelper
  def via_hypothesis(url)
    "https://via.hypothes.is/#{url}"
  end

  def resource_type_path(resource)
    {
      'Resource' => resource_path(resource),
      'Network' => network_path(resource),
      'List' => '#'
    }[resource.class.to_s]
  end
end
