namespace :etl do
  desc 'ETL task to import local .json resource array files'

  task import_local_json_resources: :environment do
    etl_filename = 'lib/etl/process_local_json_resources.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end

  desc 'ETL task to import local .json group array files'

  task import_local_json_groups: :environment do
    etl_filename = 'lib/etl/process_local_json_groups.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end

  desc 'ETL task to import .json resource array files from our S3 bucket'

  task import_s3_json_resources: :environment do
    etl_filename = 'lib/etl/process_s3_json_resources.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end

  desc 'ETL task to import .json group array files from our S3 bucket'

  task import_s3_json_groups: :environment do
    etl_filename = 'lib/etl/process_s3_json_groups.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end
end
