require 'aws-sdk'
require 'tempfile'

class ProcessAllFilesInS3Folders
  def initialize(bucket_name, prefix_folders, file_ext, region = nil)
    @bucket_name = bucket_name
    @prefix_folders = prefix_folders
    @file_ext = file_ext
    @region = region
  end

  def each
    filtered_files.each do |file_key|
      Tempfile.open(['s3data', file_ext], dir, binmode: true) do |tempfile|
        ap "Processing #{tempfile}..."

        s3.get_object(
          response_target: tempfile.path,
          bucket: bucket_name,
          key: file_key,
        )

        yield(tempfile, file_key)
      end
    end
  end

  private

  attr_reader :bucket_name, :prefix_folders, :file_ext

  def dir
    "#{Rails.root}/tmp"
  end

  def filtered_files
    file_keys.grep(/#{file_ext}/)
  end

  def file_keys
    [*prefix_folders].map do |prefix_folder|
      s3.list_objects(bucket_location(prefix_folder)).contents.map(&:key)
    end.flatten
  end

  def s3
    p @region
    @_s3 = Aws::S3::Client.new(region: @region || ENV['AWS_REGION'])
  end

  def bucket_location(prefix_folder)
    { bucket: bucket_name, prefix: prefix_folder }
  end
end
