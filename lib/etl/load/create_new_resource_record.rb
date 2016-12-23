class CreateNewResourceRecord
  def write(attributes)
    @attributes = attributes

    if existing_record
      ap "Title already in database: #{title}" # rubocop:disable Rails/Output
    else
      record = Resource.create!(attributes)

      ap "Title: #{record.title}" # rubocop:disable Rails/Output
      ap 'Metadata: ' # rubocop:disable Rails/Output
      ap record.metadata # rubocop:disable Rails/Output
      ap "Content: #{record.content.truncate(100)}" # rubocop:disable Rails/Output
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
