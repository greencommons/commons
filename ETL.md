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

Then run the rake tasks below to import the records,
transform them,
and load them into the database.

*There are currently two types of ETL processes available: `JSON processing` and `EPUB processing`. Prefer the JSON version when possible.*

### JSON Files

The JSON ETL should be seen as the default one since it results in less errors than running the EPUB one (see next section).

#### With local test files:

```
bundle exec rake etl:import_local_json_resources
bundle exec rake etl:import_local_json_groups
```

#### With files from S3

```
bundle exec rake etl:import_s3_json_resources
bundle exec rake etl:import_s3_json_groups
```

### Epub Files

#### With local test files:

```
bundle exec rake etl:import_local_epub
```

#### With files from S3:

```
bundle exec rake etl:import_s3_epub
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
│   ├── sample_island_press_1.epub
│   ├── sample_island_press_2.epub
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
