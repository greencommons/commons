class CreateNewResourceRecord
  def write(attributes)
    @attributes = attributes

    unless @attributes.is_a? Hash
      ap 'Error: given attributes were not provided as a hash:'
      ap @attributes
      return
    end

    if existing_record
      ap "Title already in database: #{title}"
    else
      ap 'Saving...'
      record = Resource.create!(attributes)

      ap "Title: #{record.title}"
      ap 'Metadata: '
      ap record.metadata
      ap "Content: #{record.content.truncate(100)}"
    end
  end

  private

  attr_reader :attributes

  def existing_record
    Resource.find_by(title: title)
  end

  def title
    attributes.fetch(:title)
  end
end
