class ETL
  def self.run(filename)
    etl_filename = filename
    script_content = IO.read(etl_filename)
    job_definition = Kiba.parse(script_content, etl_filename)
    Kiba.run(job_definition)
  end
end
