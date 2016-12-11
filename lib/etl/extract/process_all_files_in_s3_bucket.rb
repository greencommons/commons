require 'aws-sdk'
require 'tempfile'

class ProcessAllFilesInS3Bucket
  def initialize(bucket_name, prefix_folder)
    @bucket_name = bucket_name
    @prefix_folder = prefix_folder
  end

  def each
    epub_files.each do |epub_key|
      Tempfile.open(['island_press', '.epub'], dir, binmode: true) do |tempfile|
        s3.get_object(
          response_target: tempfile.path,
          bucket: bucket_name,
          key: epub_key,
        )

        yield(tempfile, epub_key)
      end
    end
  end

  private

  attr_reader :bucket_name, :prefix_folder

  def dir
    "#{Rails.root}/tmp"
  end

  def epub_files
    file_keys.grep(/\.epub$/)
  end

  def file_keys
    s3.list_objects(bucket_location).contents.map(&:key)
  end

  def s3
    @_s3 = Aws::S3::Client.new
  end

  def bucket_location
    { bucket: bucket_name, prefix: prefix_folder }
  end
end
