class CreateNewResourceRecord < CreateNewRecord
  private

  def existing_record
    Resource.find_by(title: record_name)
  end

  def record_name
    attributes.fetch(:title)
  end

  def create
    tags = attributes.delete(:tags) if attributes[:tags]
    attributes[:url] = attributes.delete(:content_url)
    attributes[:privacy] = :publ
    record = Resource.create!(attributes)

    if tags && tags.any?
      tags.each { |tag| record.tag_list.add(tag) }
      record.save
    end

    ap "Title: #{record.title}"
    ap 'Metadata: '
    ap record.metadata
    ap "Content: #{record.short_content.truncate(100)}"
  end
end
