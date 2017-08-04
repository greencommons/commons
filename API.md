# Web API Usage

### Authentication

Green Commons uses a custom HTTP Authentication scheme in order to authenticate the requests. For resources requiring authentication, you need to pass the `Authorization` header in the following format:

```
Authorization: GC access_key:secret_key
```

Your `access_key` and `secret_key` can be found in your profile. In the `curl` request examples below, fake keys are being used (`access_key` and `secret_key`), __replace them with your personal keys__. You will also want to change the IDs in order to interact with real resources.

### JSON API

The Green Commons Web API follows the [JSON API specification](http://jsonapi.org/) to facilitate the integration in your projects. Specify the content-type of your request using by setting the `Content-Type` header.

```
Content-Type: application/vnd.api+json
```

### Available Resources

- [Search](#search)
- [Resources](#resources)
- [Networks](#networks)
- [Lists](#lists)

#### Search - `/api/v1/search`

The search endpoint can be used to search through resources, networks and lists. It accepts some query parameters allowing you to customize the results.

__Query Parameters__

- `q`: The term to search for.
- `filters`: Filters to apply to the search. For now, results can only be filtered by class or `resource_type`. Supported Values:
  - `filters[resource_types]=articles,books,reports,urls,audios,courses,datasets,images,syllabuses,videos,profiles`
  - `filters[model_types]=resources,lists,networks`
- `sort`: Field to sort the results by. Supported Values:
  - `sort=published_at` (Ascending)
  - `sort=-published_at` (Descending)
- `page`: The page to retrieve.
- `per`: Number of results per page.

More filters and sorting options are coming soon.

__Example__

```
curl -g -X GET 'https://greencommons.herokuapp.com/api/v1/search?q=wind&filters[resource_types]=articles,reports&filters[model_types]=resources,lists,networks&page=2&per=5'
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
      "self":"https://greencommons.herokuapp.com/api/v1/search?q=wind&filters[resource_types]=articles,reports&filters[model_types]=resources,lists,networks&page=2&per=5",
      "next":"",
      "last":""
   },
   "included":[]
}
```

#### Resources

##### Retrieve a resource - `/api/v1/resources/:id`

```
curl http://greencommons.herokuapp.com/api/v1/resources/43130
```

Or to access a private resource belonging to you:

```
curl -H 'Authorization: GC access_key:secret_key' \
http://greencommons.herokuapp.com/api/v1/resources/63243
```

##### Create a resource

```
curl http://greencommons.herokuapp.com/api/v1/resources \
     -X POST \
     -v \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "resources", "attributes": { "title": "A new resource" } } }'
```

##### Update a resource

```
curl http://greencommons.herokuapp.com/api/v1/resources/63244 \
     -X PATCH \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "id": "63244", "type": "resources", "attributes": { "title": "An updated resource" } } }'
```

#### Networks

##### Retrieve all networks - `/api/v1/networks`

All the query parameters defined for the `/search` resource can be used here as well.

```
curl http://greencommons.herokuapp.com/api/v1/networks
```

##### Retrieve a network - `/api/v1/networks/:id`

__Example__

```
curl http://greencommons.herokuapp.com/api/v1/networks/2129
```

##### Create a network

```
curl http://greencommons.herokuapp.com/api/v1/networks \
     -X POST \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "networks", "attributes": { "name": "A new network" } } }'
```

##### Update a network

```
curl http://greencommons.herokuapp.com/api/v1/networks/2140 \
     -X PATCH \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "id": "2140", "type": "networks", "attributes": { "name": "A new network" } } }'
```

#### Network Users

##### List network users

```
curl http://greencommons.herokuapp.com/api/v1/networks/2140/relationships/users
```

Note that it is also possible to just include the members when retrieving a network:

```
curl 'http://greencommons.herokuapp.com/api/v1/networks/2140?include=users'
```

##### Add users to a network

```
curl http://greencommons.herokuapp.com/api/v1/networks/2140/relationships/users \
     -X POST \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "1", "type": "users" }] }'
```

##### Remove users from a network

```
curl http://greencommons.herokuapp.com/api/v1/networks/2140/relationships/users \
     -X DELETE \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "1", "type": "users" }] }'
```

#### Lists

##### Retrieve a list - `/api/v1/lists/:id`

__Example__

```
curl http://greencommons.herokuapp.com/api/v1/lists/93
```

##### Create a list

```
curl http://greencommons.herokuapp.com/api/v1/lists \
     -X POST \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "lists", "attributes": { "name": "A new list" } } }'
```

##### Add to a list

```
curl http://greencommons.herokuapp.com/api/v1/lists/93/relationships/items \
     -X POST \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "2140", "type": "networks" }, { "id": "43130", "type": "resources" }] }'
```

##### Remove from a list

```
curl http://greencommons.herokuapp.com/api/v1/lists/93/relationships/items \
     -X DELETE \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": [{ "id": "2140", "type": "networks" }, { "id": "43130", "type": "resources" }] }'
```

#### Users

##### Create users

```
curl http://greencommons.herokuapp.com/api/v1/users \
     -X POST \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "type": "users", "attributes": { "email": "john@example.com", "password": "password", "password_confirmation": "password"} } }'
```

##### Update user

```
curl http://greencommons.herokuapp.com/api/v1/users/10 \
     -X PATCH \
     -H 'Authorization: GC access_key:secret_key' \
     -H 'Content-Type: application/vnd.api+json' \
     -d '{ "data": { "id": "10", "type": "users", "attributes": { "first_name": "John" } } }'
```
