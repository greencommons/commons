require 'json'
require 'json-schema'

class NormalizeJson
  def process(input)
    @input = input
    json = parse_json

    if json
      JSON::Validator.validate(schema_fname, json)
      yield json
    end
  end

  private

  attr_reader :input, :schema_fname

  def schema_fname
    raise NotImplementedError.new("#{self.class.name}#schema_fname is an abstract method.")
  end

  def parse_json
    JSON.parse(File.read(input), symbolize_names: true)
  rescue StandardError => e
    ap "Error opening json file: #{e}"
  end
end

class NormalizeJsonResources < NormalizeJson
  def schema_fname
    'lib/etl/schema/resource_array_schema.json'
  end
end

class NormalizeJsonGroups < NormalizeJson
  def schema_fname
    'lib/etl/schema/group_array_schema.json'
  end
end
