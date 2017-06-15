class CreateNewNetworkRecord < CreateNewRecord
  private

  def existing_record
    Network.find_by(name: record_name)
  end

  def record_name
    attributes.fetch(:name)
  end

  def create
    tags = attributes.delete(:tags) if attributes[:tags]
    record = Network.create!(attributes)

    if tags && tags.any?
      tags.each { |tag| record.tag_list.add(tag) }
      record.save
    end

    ap "Name: #{record.name}"
    ap 'Metadata: '
    ap record.metadata
    ap record.long_description
  end
end
