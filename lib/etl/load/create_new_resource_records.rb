class CreateNewResourceRecords
  def write(attributes_list)
    @attributes_list = attributes_list

    attributes_list.each do |attributes|
      puts "#{attributes["title"]}"
      
      if existing_record attributes
        ap "Title already in database: #{title attributes}" # rubocop:disable Rails/Output
      else
        record = Resource.create!(attributes)

        ap "Title: #{record.title}" # rubocop:disable Rails/Output
        ap 'Metadata: ' # rubocop:disable Rails/Output
        ap record.metadata # rubocop:disable Rails/Output
        ap "Content: #{record.content.truncate(100)}" # rubocop:disable Rails/Output
      end
    end
  end

  private

  attr_reader :attributes_list

  def existing_record(attributes)
    Resource.find_by(title: title(attributes))
  end

  def title(attributes)
    attributes.fetch(:title)
  end
end
