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

### Authentication

Green Commons uses a custom HTTP Authentication scheme in order to authenticate the requests. For resources requiring authentication, you need to pass the `Authorization` header in the following format:

```
Authorization: GC access_key:secret_key
```

Your `access_key` and `secret_key` can be found in your profile.

### JSON API

The Green Commons Web API follows the [JSON API specification](http://jsonapi.org/) to facilitate the integration in your projects. Specify the content-type of your request using by setting the `Content-Type` header.

```
Content-Type: application/vnd.api+json
```

### Available Resources

- [Search](#search)
- Resources
- Groups
- Lists

#### Search - `/api/v1/search`

The search endpoint can be used to search through resources, groups and lists. It accepts some query parameters allowing you to customize the results.

__Query Parameters__

- `q`: The term to search for.
- `filters`: Filters to apply to the search. For now, results can only be filtered by class or `resource_type`. Supported Values:
  - `filters[resource_types]=books,articles,reports`
  - `filters[model_types]=resources,lists,groups`
- `sort`: Field to sort the results by. Supported Values:
  - `sort=published_at` (Ascending)
  - `sort=-published_at` (Descending)
- `page`: The page to retrieve.
- `per`: Number of results per page.

More filters and sorting options are coming soon.

__Example__

```
curl -g -X GET 'https://greencommons.herokuapp.com/api/v1/search?q=wind&filters[resource_types]=articles,reports&filters[model_types]=resources,lists,groups&page=2&per=5'
```

```
{  
   "data":[  
      {  
         "type":"resources",
         "id":"504",
         "attributes":{  
            "title":"The Upside of Down: Catastrophe, Creativity, and the Renewal of Civilization",
            "excerpt":"...",
            "published_at":"2017-01-05T14:14:49.305Z",
            "tags":[],
            "resource_type":"article"
         },
         "links":{  
            "self":"https://greencommons.herokuapp.com/api/v1/resources/504"
         },
         "relationships":{  
            "lists":{  
               "data":[  

               ],
               "links":{  
                  "self":"https://greencommons.herokuapp.com/api/v1/resources/504/relationships/lists",
                  "related":"https://greencommons.herokuapp.com/api/v1/resources/504/lists"
               }
            }
         }
      },
      { ... }
   ],
   "links":{  
      "self":"https://greencommons.herokuapp.com/api/v1/search?q=wind&filters[resource_types]=articles,reports&filters[model_types]=resources,lists,groups&page=2&per=5",
      "next":"",
      "last":""
   },
   "included":[]
}
```

#### Resources

##### Retrieve a resource - `/api/v1/resources/:id`

```
curl http://greencommons.herokuapp.com/api/v1/resources/7577
```

##### Create a resource

```
curl http://greencommons.herokuapp.com/api/v1/resources \
     -X POST \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "resources", "attributes": { "title": "A new resource" } } }'
```

##### Update a resource

```
curl http://greencommons.herokuapp.com/api/v1/resources/:id \
     -X PATCH \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "id": ":id", "type": "resources", "attributes": { "title": "An updated resource" } } }'
```

#### Groups

##### Retrieve all groups - `/api/v1/groups`

All the query parameters defined for the `/search` resource can be used here as well.

```
curl http://greencommons.herokuapp.com/api/v1/groups
```

##### Retrieve a group - `/api/v1/groups/:id`

__Example__

```
curl http://greencommons.herokuapp.com/api/v1/groups/10
```

```
{  
  "data":{  
    "type":"groups",
    "id":"10",
    "attributes":{  
      "name":"Mertz, Wisozk and Marks",
      "short_description":"Ad non quia laborum enim.",
      "long_description":"Enim recusandae vitae. Nam ut qui cum. Molestiae suscipit quae culpa sint possimus. Quo officiis perferendis. Est est et ut ullam qui commodi.",
      "relevancy":null,
      "tags":[  

      ],
      "published_at":null,
      "members_count":9,
      "lists_count":5,
      "resources_count":164
    },
    "links":{  
      "self":"http://greencommons.herokuapp.com/api/v1/groups/10"
    },
    "relationships":{  
      "users":{  
        "data":[  
          {  
            "type":"users",
            "id":"1"
          },
          {  
            "type":"users",
            "id":"6"
          },
          {  
            "type":"users",
            "id":"2"
          },
          {  
            "type":"users",
            "id":"10"
          },
          {  
            "type":"users",
            "id":"5"
          },
          {  
            "type":"users",
            "id":"8"
          },
          {  
            "type":"users",
            "id":"4"
          },
          {  
            "type":"users",
            "id":"9"
          },
          {  
            "type":"users",
            "id":"7"
          }
        ],
        "links":{  
          "self":"http://greencommons.herokuapp.com/api/v1/groups/10/relationships/users",
          "related":"http://greencommons.herokuapp.com/api/v1/groups/10/users"
        }
      }
    }
  },
  "links":{  
    "self":"http://greencommons.herokuapp.com/api/v1/groups/10",
    "next":"",
    "last":""
  },
  "included":[]
}
```

##### Create a group

```
curl http://localhost:3000/api/v1/groups \
     -X POST \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "groups", "attributes": { "name": "A new group" } } }'
```

##### Update a group

```
curl http://localhost:3000/api/v1/groups/:id \
     -X PATCH \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "id": ":id", "type": "groups", "attributes": { "name": "A new group" } } }'
```

#### Group Users

##### List group users

```
curl http://greencommons.herokuapp.com/api/v1/groups/:id/relationships/members
```

Note that it is also possible to just include the members when retrieving a group:

```
curl http://greencommons.herokuapp.com/api/v1/groups/:id?include=users
```

##### Add users to a group

```
curl http://greencommons.herokuapp.com/api/v1/groups/:id/relationships/users \
     -X POST \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "1", "type": "users" }] }'
```

##### Remove users from a group

```
curl http://greencommons.herokuapp.com/api/v1/groups/:id/relationships/users \
     -X DELETE \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "1", "type": "users" }] }'
```

#### Lists

##### Retrieve a list - `/api/v1/lists/:id`

__Example__

```
curl http://greencommons.herokuapp.com/api/v1/lists/10
```

##### Create a list

```
curl http://greencommons.herokuapp.com/api/v1/lists \
     -X POST \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "lists", "attributes": { "name": "A new list" } } }'
```

##### Add to a list

```
curl http://greencommons.herokuapp.com/api/v1/lists/:id/relationships/items \
     -X POST \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "1", "type": "groups" }, { "id": "1", "type": "resources" }] }'
```

##### Remove from a list

```
curl http://greencommons.herokuapp.com/api/v1/lists/:id/relationships/items \
     -X DELETE \
     -H 'Authorization: GC aXq8R267J_v1uXk5pbvU5g:1f9413d519c881a5cfc3c15faf6cd17e' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "1", "type": "groups" }, { "id": "1", "type": "resources" }] }'
```
