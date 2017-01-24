class CreateNewGroupRecord < CreateNewRecord

  private

  def existing_record
    Group.find_by(name: record_name)
  end

  def record_name
    attributes.fetch(:name)
  end

  def create
    record = Group.create!(attributes)

    ap "Name: #{record.name}"
    ap 'Metadata: '
    ap record.metadata
    ap record.long_description
  end
end
