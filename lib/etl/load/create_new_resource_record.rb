class CreateNewResourceRecord
  def write(attributes)
    record = Resource.create!(attributes)

    ap "Title: #{record.title}"
    ap 'Metadata: '
    ap record.metadata
    ap "Content: #{record.content.truncate(100)}"
  end
end
