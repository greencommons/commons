class Resources::FileProcessor
  def initialize(resource)
    @resource = resource
  end

  def call
    download_file
    extract_content
  end

  private

  def download_file
    @file = S3.new.fetch_file(URI(@resource.content_download_link).path[1..-1])
  end

  def extract_content
    @resource.long_content = ''
    PDF::Reader.new(StringIO.new(@file.body, 'rb')).pages.each do |page|
      @resource.long_content += page.text
    end
    @resource.save
  end
end
