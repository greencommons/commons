Green Commons
=============

[![CircleCI](https://circleci.com/gh/greencommons/commons/tree/master.svg?style=svg)](https://circleci.com/gh/greencommons/commons/tree/master) [![Code Climate](https://codeclimate.com/github/greencommons/commons/badges/gpa.svg)](https://codeclimate.com/github/greencommons/commons)

This is the repository for the Green Commons project.

Servers
-------

|    branch   |environment|remote|URL|
|-------------|-----------|------|---|
|`master`     |production|`git@heroku.com:greencommons.git`|[greencommons.net](https://greencommons.net)|


Note: Pushing to `master` will auto-deploy to production.


Contributing
------------

We follow [thoughtbot's git guide](https://github.com/thoughtbot/guides/tree/master/protocol/git) to determine the development workflow.



Setup (OS X)
------------

#### Prerequisites

- [Heroku Toolbelt]
- Ruby, >= 2.3.2
- Postgres
- QT ([install instructions here])
- [XCode] 8.0+

You can install most of the above with [Homebrew]. For Postgres, @ptrikutam uses [Postgres.app] but you're welcome to set it up however you like.

[Heroku Toolbelt]: https://toolbelt.heroku.com/
[Homebrew]: http://brew.sh/
[Postgres.app]: http://postgresapp.com/
[install instructions here]: https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit#macos-sierra-1012
[XCode]: https://developer.apple.com/xcode/

#### Setting up the repository

Clone the repo and run the setup script:

    git clone git@github.com:greencommons/commons.git
    cd commons
    ./bin/setup

To start the app locally run the command (make sure postgres is running):

    foreman start -f Procfile.dev

You should be able to visit http://localhost:3000/ within your browser and see the Green Commons homepage.

You will need to run the following while you have foreman running in another terminal window, otherwise you will get ElasticSearch errors:

    rake elasticsearch:create:all_indices

Developing
----------

You can optionally use [`guard-livereload`]
to refresh the page automatically
when you've saved changes to a file.

Run

```
bundle exec guard
```

and be sure to install the appropriate browser extension
listed in the gem's `README.md`.

[`guard-livereload`]: https://github.com/guard/guard-livereload

Using the ElasticSearch Index
-----------------------------

Anything added, created, or deleted in the `Resource` model will automatically be indexed in ElasticSearch. If you'd like to recreate the index for any reason, you can use the following rake task:

```
bundle exec rake elasticsearch:reset_resource_index
```

This will delete the index and re-import all the records in the resources table.


Testing
-------

We test using [rspec]/[rspec-rails]. You can run the test suite by running:

    bundle exec rake

[rspec]: https://github.com/rspec/rspec
[rspec-rails]: https://github.com/rspec/rspec-rails

Updating Gems
-------------

We should update gems regularly for security and bugfix reasons.
We use a tool called [bummr] to update the dependencies for us.
It will update each gem individually, then run the tests and if any fail,
use `git bisect` to figure out which one is the problem.

Every [week or so], run this command:

```
bummr update
```

[bummr]: https://github.com/lpender/bummr
[week or so]: http://adarsh.io/save-money-and-be-happier-by-updating-your-gems-every-monday-morning/

Adding New Resources to the Database
------------------------------------

See [ETL.md](ETL.md) for more information.

Web API Usage
------------------------------------

See [API.md](API.md) for more information.
