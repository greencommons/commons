# Source files (lib/etl/extract)
require_relative 'extract/process_all_files_in_local_folder'
require_relative 'extract/process_all_files_in_s3_bucket'

# Transform files (lib/etl/transform)
require_relative 'transform/transform_epub'

# Destination files (lib/etl/load)
require_relative 'load/create_new_resource_record'
