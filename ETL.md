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
bundle exec rake etl:local_json_resources_to_db
bundle exec rake etl:local_json_networks_to_db
```

#### With files from S3

```
bundle exec rake etl:s3_json_resources_to_db
bundle exec rake etl:s3_validcommons_json_resources_to_db
bundle exec rake etl:s3_validcommons_json_networks_to_db
bundle exec rake etl:s3_json_networks_to_db
```

### Epub Files

#### With local test files:

```
bundle exec rake etl:local_epubs_to_db
```

#### With files from S3:

```
bundle exec rake etl:s3_islandpress_epubs_to_db
```

## Development

### Directory Structure

kiba ETL source files are in `lib/etl/`

```
├── common.rb
├── local_epubs_to_db.etl
├── local_json_resources_to_db.etl
├── local_json_networks_to_db.etl
├── s3_islandpress_epubs_to_db.etl
├── s3_json_resources_to_db.etl
├── s3_json_networks_to_db.etl
├── data
│   ├── sample_epub_book_1.epub
│   ├── sample_epub_book_2.epub
│   ├── corrupted_sample_epub_book_3.epub
│   ├── good_resource_array.json
│   ├── bad_resource_array.json
│   └── good_network_array.json
│   └── bad_network_array.json
├── extract
│   └── process_files_all_files_in_local_folders.rb
│   └── process_files_all_files_in_s3_folders.rb
├── normalize
│   └── normalize_row.rb
│   └── normalize_json.rb
├── load
│   ├── create_new_record.rb
│   ├── create_new_resource_record.rb
│   └── create_new_network_record.rb
├── transform
│   └── transform_epub.rb
└── schema
    ├── resource_array_schema.json
    └── network_array_schema.json

```

### Rake Tasks

Rake tasks are in `lib/tasks` and namespaced, as `etl:your_new_rake_task_name`.
