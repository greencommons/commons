module GlyphiconHelper
  RESOURCE_ICONS = {
    article: 'file',
    book: 'book',
    report: 'info-sign',
  }

  def resource_icon(resource)
    RESOURCE_ICONS[resource.resource_type.to_sym]
  end
end
