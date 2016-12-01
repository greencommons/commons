namespace :etl do
  desc 'ETL task to import local .epub files'

  task import_local_epub: :environment do
    etl_filename = 'lib/etl/convert-islandpress.etl'
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end
end
