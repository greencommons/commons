require 'aws-sdk'
require 'tempfile'

class ProcessFilesInS3BucketFolders
  def initialize(bucket_name, prefix_folders, file_ext)
    @bucket_name = bucket_name
    @prefix_folders = prefix_folders
    @file_ext = file_ext
  end

  def each
    filtered_files.each do |file_key|
      Tempfile.open('s3data', dir, binmode: true) do |tempfile|
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
    arr = []
    @prefix_folders.each do |prefix_folder|
      arr += s3.list_objects(bucket_location(prefix_folder)).contents.map(&:key)
    end
    arr
  end

  def s3
    @_s3 = Aws::S3::Client.new
  end

  def bucket_location(prefix_folder)
    { bucket: bucket_name, prefix: prefix_folder }
  end
end
