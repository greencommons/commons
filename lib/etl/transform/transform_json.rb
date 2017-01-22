require 'json'
require 'json-schema'

class TransformJson
  def process(input_json)
    @input_json = input_json
    pl = parsed_list
    JSON::Validator.validate(schema_fname, pl)
    pl
    
  rescue => error
    ap "Error opening json file: #{error}"
  end

  private

  attr_reader :input_json, :schema_fname
  
  def schema_fname
    raise NotImplementedError.new("#{self.class.name}#area is an abstract method.")
  end
  
  def parsed_list
    JSON.parse(File.read(input_json), :symbolize_names => true)
  end
end

class TransformJsonResources < TransformJson
  def schema_fname
    "lib/etl/schema/resource_array_schema.json"
  end
end

class TransformJsonGroups < TransformJson
  def schema_fname
    "lib/etl/schema/group_array_schema.json"
  end
end
