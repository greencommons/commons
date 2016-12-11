namespace :etl do
  desc 'ETL task to import local .epub files'

  task import_local_epub: :environment do
    etl_filename = 'lib/etl/convert_islandpress.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end

  desc 'ETL task to import .epub files from our S3 bucket'

  task import_s3_epub: :environment do
    etl_filename = 'lib/etl/s3_islandpress_to_db.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end
end
