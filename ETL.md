# Green Commons ETL

## Introduction

These are the Extract-Transform-Load (ETL)
scripts for importing books and other resources
into the Green Commons database.

We are using the [`kiba`] gem
to set up ETL pipelines.

[`kiba`]: https://github.com/thbar/kiba

The basic format of one kiba ETL script is as follows:

```ruby
# lib/etl/example_etl_script.etl
#
# Common files required by all processes.
require_relative 'common'

# Define a source of data to import. In this case, a directory of files.
# a source file needs to only have a constructor and `.each` method.
source(ProcessAllFilesInLocalFolder, 'lib/etl/*.epub')

# How to transform one of the above source items. Expected output is a hash.
transform(TransformEpub)

# What to do with the hash resulting from the above transformation.
# Here, we are using the hash attributes to create a new database record.
destination(CreateNewResourceRecord)
```

For more information, see the [`kiba`] `README.md` file.

## Usage

Then run the rake tasks to import the records,
transform them,
and load them into the database:

```
with local test files:

bundle exec rake etl:import_local_json_resources
bundle exec rake etl:import_local_json_groups

or with files from S3:

bundle exec rake etl:import_s3_json_resources
bundle exec rake etl:import_s3_json_groups
```

## Development

### Directory Structure

kiba ETL source files are in `lib/etl/`

```
├── common.rb
├── process_local_json_resources.etl
├── process_local_json_groups.etl
├── process_s3_json_resources.etl
├── process_s3_json_groups.etl
├── data
│   ├── good_resource_array.json
│   └── good_group_array.json
├── extract
│   └── process_files_in_s3_bucket_folders.rb
├── load
│   ├── create_new_resource_records.rb
│   └── create_new_group_records.rb
├── transform
│   └── transform_json.rb
└── schema
    ├── resource_array_schema.json
    └── group_array_schema.json
    
```

### Rake Tasks

Rake tasks are in `lib/tasks` and namespaced, as `etl:your_new_rake_task_name`.
