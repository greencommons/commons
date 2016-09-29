Green Commons
=============

[![CircleCI](https://circleci.com/gh/greencommons/commons/tree/master.svg?style=svg)](https://circleci.com/gh/greencommons/commons/tree/master) [![Code Climate](https://codeclimate.com/github/greencommons/commons/badges/gpa.svg)](https://codeclimate.com/github/greencommons/commons)

This is the repository for the Green Commons project.

Servers
-------

|    branch   |environment|remote|URL|
|-------------|-----------|------|---|
|`master`     |production|`git@heroku.com:greencommons.git`|[greencommons.herokuapp.com](https://greencommons.herokuapp.com)|


Note: Pushing to `master` will auto-deploy to production.


Contributing
------------

We follow [thoughtbot's git guide](https://github.com/thoughtbot/guides/tree/master/protocol/git) to determine the development workflow.



Setup (OS X)
------------

#### Perequisites

- [Heroku Toolbelt]
- Ruby, >= 2.3.1
- Postgres

You can install most of the above with [Homebrew]. For Postgres, @ptrikutam uses [Postgres.app] but you're welcome to set it up however you like.

[Heroku Toolbelt]: https://toolbelt.heroku.com/
[Homebrew]: http://brew.sh/
[Postgres.app]: http://postgresapp.com/

#### Setting up the repository

Clone the repo and run the setup script:

    git clone git@github.com:greencommons/commons.git
    cd commons
    ./bin/setup

To start the app locally run the command (make sure postgres is running):

    foreman start -f Procfile.dev