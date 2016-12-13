class CreateNewResourceRecord
  def write(attributes)
    record = Resource.create!(attributes)

    ap "Title: #{record.title}" # rubocop:disable Rails/Output
    ap 'Metadata: ' # rubocop:disable Rails/Output
    ap record.metadata # rubocop:disable Rails/Output
    ap "Content: #{record.content.truncate(100)}" # rubocop:disable Rails/Output
  end
end
