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

  def link_to_back(title, *options)
    to_back = begin
      if back_to_previous_page?
        :back
      else
        root_url
      end
    end
    link_to(title, to_back, *options)
  end

  def back_to_previous_page?
    request.env['HTTP_REFERER'].present? &&
       request.env['HTTP_REFERER'].include?(request.host) &&
       !request.env['HTTP_REFERER'].match(/new|edit/)
  end
end
