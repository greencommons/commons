class S3
  ACCESS_KEY_ID = ENV.fetch('AWS_ACCESS_KEY_ID')
  SECRET_ACCESS_KEY = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  BUCKET = ENV.fetch('AWS_UPLOADS_BUCKET')
  REGION = ENV.fetch('AWS_REGION')
  MAX_UPLOAD_FILESIZE = Rails.application.config.max_upload_filesize
  SIGNED_URL_EXPIRATION_TIME = Rails.application.config.signed_url_expiration_time

  def initialize; end

  def signed_url(path)
    connection.directories.new(key: BUCKET).files.new(key: path).
      url(Time.now.to_i + SIGNED_URL_EXPIRATION_TIME)
  end

  def generate_signature(path, acl = 'public-read')
    policy = s3_upload_policy_document(path, acl)
    {
      policy: policy,
      signature: s3_upload_signature(policy),
      key: path,
      success_action_redirect: '/',
      mime_type: mime_type_of(path),
      acl: acl
    }
  end

  def file_exists?(path)
    root_directory.files.head(path).present?
  end

  def fetch_file(path)
    root_directory.files.get(path)
  end

  private

  def connection
    @connection ||= Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ACCESS_KEY_ID,
      aws_secret_access_key: SECRET_ACCESS_KEY,
      region: REGION
    )
  end

  def s3_upload_policy_document(path, acl)
    ret = {
      'expiration' => 5.minutes.from_now.utc.xmlschema,
      'conditions' => [
        { 'bucket' => BUCKET },
        { 'success_action_status' => '200' },
        { 'acl' => acl },
        { 'Content-Type' => mime_type_of(path) },
        ['starts-with', '$key', path],
        ['content-length-range', 0, MAX_UPLOAD_FILESIZE]
      ]
    }
    Base64.encode64(ret.to_json).delete("\n")
  end

  def s3_upload_signature(policy)
    digest = OpenSSL::HMAC.digest(
      OpenSSL::Digest.new('sha1'),
      SECRET_ACCESS_KEY,
      policy
    )
    Base64.encode64(digest).delete("\n")
  end

  def mime_type_of(path)
    mime_type = Mime::Type.lookup_by_extension(extension_of(path))
    mime_type ? mime_type.to_str : 'binary/octet-stream'
  end

  def extension_of(path)
    File.extname(path)[1..-1]
  end

  def root_directory
    @root_directory ||= connection.directories.get(BUCKET)
  end
end
