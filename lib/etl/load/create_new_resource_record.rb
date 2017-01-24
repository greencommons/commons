class CreateNewResourceRecord < CreateNewRecord

  private

  def existing_record
    Resource.find_by(title: record_name)
  end

  def record_name
    attributes.fetch(:title)
  end

  def create
    record = Resource.create!(attributes)

    ap "Title: #{record.title}"
    ap 'Metadata: '
    ap record.metadata
    ap "Content: #{record.content.truncate(100)}"
  end
end
