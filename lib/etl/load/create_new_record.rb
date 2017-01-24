class CreateNewRecord
  def write(attributes)
    @attributes = attributes

    unless @attributes.is_a? Hash
      ap 'Error: given attributes were not provided as a hash:'
      ap @attributes
      return
    end

    if existing_record
      ap "Record already in database: #{record_name}"
    else
      ap 'Saving...'
      create
    end
  end

  private

  attr_reader :attributes

  def existing_record
    raise NotImplementedError.new("#{self.class.name}#record_name is an abstract method.")
  end

  def record_name
    raise NotImplementedError.new("#{self.class.name}#record_name is an abstract method.")
  end

  def create
    raise NotImplementedError.new("#{self.class.name}#create is an abstract method.")
  end
end
