class ResourcePathBuilder
  def self.generate(filename)
    File.join('resources', SecureRandom.uuid, filename)
  end
end
