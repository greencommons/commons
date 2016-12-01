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

Then run the rake task to import the records,
transform them,
and load them into the database:

```
bundle exec rake etl:import_local_epub
```

## Development

### Directory Structure

kiba ETL source files are in `lib/etl/`

```
├── common.rb
├── convert-islandpress.etl
├── data
│   ├── sample_island_press_1.epub
│   └── sample_island_press_2.epub
├── extract
│   └── process_all_files_in_local_folder.rb
├── load
│   └── create_new_resource_record.rb
└── transform
    └── transform_epub.rb
```

### Rake Tasks

Rake tasks are in `lib/tasks` and namespaced, as `etl:your_new_rake_task_name`.
