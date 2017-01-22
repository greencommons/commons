class CreateNewGroupRecords
  def write(attributes_list)
    @attributes_list = attributes_list

    attributes_list.each do |attributes|
      puts "#{attributes["name"]}"
      
      if existing_record attributes
        ap "Name already in database: #{name attributes}" # rubocop:disable Rails/Output
      else
        record = Group.create!(attributes)

        ap "Name: #{record.name}" # rubocop:disable Rails/Output
        ap 'Metadata: ' # rubocop:disable Rails/Output
        ap record.metadata # rubocop:disable Rails/Output
        ap record.long_description # rubocop:disable Rails/Output
      end
    end
  end

  private

  attr_reader :attributes_list

  def existing_record(attributes)
    Group.find_by(name: name(attributes))
  end

  def name(attributes)
    attributes.fetch(:name)
  end
end
