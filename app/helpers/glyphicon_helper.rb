module GlyphiconHelper
  RESOURCE_ICONS = {
    article: 'file-text',
    book: 'book',
    report: 'clipboard',
    url: 'link'
  }.freeze

  def resource_icon(resource)
    RESOURCE_ICONS[resource.resource_type.to_sym]
  end
end
