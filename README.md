# Green Commons

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

Clone the repo and run the setup script:

    git clone git@github.com:greencommons/commons.git
    cd commons
    ./bin/setup

To start the app locally run the command:

    foreman start -f Procfile.dev