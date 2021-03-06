# Normalizers (lib/etl/normalize)
require_relative 'normalize/normalize_row'
require_relative 'normalize/normalize_json'

# Source files (lib/etl/extract)
require_relative 'extract/process_all_files_in_local_folders'
require_relative 'extract/process_all_files_in_s3_folders'

# Transform files (lib/etl/transform)
require_relative 'transform/transform_epub'

# Destination files (lib/etl/load)
require_relative 'load/create_new_record'
require_relative 'load/create_new_resource_record'
require_relative 'load/create_new_network_record'
