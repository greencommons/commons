# Source files (lib/etl/extract)
require_relative 'extract/process_all_files_in_local_folder'
require_relative 'extract/process_all_files_in_s3_bucket'
require_relative 'extract/process_files_in_s3_bucket_folders'

# Transform files (lib/etl/transform)
require_relative 'transform/transform_epub'
require_relative 'transform/transform_json'

# Destination files (lib/etl/load)
require_relative 'load/create_new_resource_record'
require_relative 'load/create_new_resource_records'
require_relative 'load/create_new_group_records'
