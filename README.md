About Application
=======
This application is built in Sinatra ruby and Mongodb.It is croud operation for bird model.

For Running Application Required Steps
============

````ruby
 - install MongoDb https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
 - git clone git@github.com:vgvinay2/birdlist.git
 - bundle install
 - bundle exec ruby server_test.rb #to run unit test case 
 - bundle exec ruby server.rb #Start the application
````
API specification
=================

Add bird
--------

### Request `POST http://localhost:4567/api/v1/birds`

 `post-birds-request.json`.
````ruby
{
  "schema": "http://json-schema.org/draft-04/schema#",
  "title": "POST /testbirds [request]",
  "description": "Add a new bird to the library",
  "type": "object",
  "required": [
    "name",
    "family",
    "continents"
  ],
  "additionalProperties": false,
  "properties": {
    "name": {
      "type": "string",
      "description": "English bird name"
    },
    "family": {
      "type": "string",
      "description": "Latin bird family name"
    },
    "continents": {
      "type": "array",
      "description": "Continents the bird exist on",
      "minItems": 1,
      "items": { "type": "string" },
      "uniqueItems": true
    },
    "added": {
      "type": "string",
      "description": "232/q12/34"
    },
    "visible": {
      "type": true,
      "description": "Determines if the bird should be visible in lists"
    }
  }
}
````
### Response
`post-birds-response.json`.
````ruby
{
  "schema": "http://json-schema.org/draft-04/schema#",
  "title": "POST /testbirds [request]",
  "description": "Add a new bird to the library",
  "type": "object",
  "required": [
    "name",
    "family",
    "continents",
    "id",
    "added",
    "visible"
  ],
  "additionalProperties": false,
  "properties": {
    "name": {
      "type": "string",
      "description": "English bird name"
    },
    "family": {
      "type": "string",
      "description": "Latin bird family name"
    },
    "continents": {
      "type": "array",
      "description": "Continents the bird exist on",
      "minItems": 1,
      "items": {
        "type": "string"
      },
      "uniqueItems": true
    },
    "added": {
      "type": "string",
      "description": "232/q12/34"
    },
    "visible": {
      "type": true,
      "description": "Determines if the bird should be visible in lists"
    },
    "id": {
      "type": "string",
      "description": "5925c5b21ba54f19cfe9685d"
    }
  },
  "added": {
    "type": "String",
    "description": "2017-05-24T00:00:00.000Z"
  },
  "visible": {
    "type": false,
    "description": ""
  },
  "status": 200
}
````

List all birds
--------------

### Request `GET /birds`

Empty body.

### Response
`get-birds-response.json`.
````ruby
[
  {
    "schema": "http://json-schema.org/draft-04/schema#",
    "title": "POST /testbirds [request]",
    "description": "Add a new bird to the library",
    "type": "object",
    "additionalProperties": false,
    "items": {
      "type": "string",
      "description": "5925c2251ba54f165724d826",
      "uniqueItems": true
    }
  },
  {
    "schema": "http://json-schema.org/draft-04/schema#",
    "title": "POST /testbirds [request]",
    "description": "Add a new bird to the library",
    "type": "object",
    "additionalProperties": false,
    "items": {
      "type": "string",
      "description": "5925c42c1ba54f190667b24c",
      "uniqueItems": true
    }
  }
  ]
````


Get bird by id
--------------

### Request `GET /birds/5925c2251ba54f165724d826`

Empty body.

### Response
````ruby
{
  "schema": "http://json-schema.org/draft-04/schema#",
  "title": "POST /testbirds [request]",
  "description": "Add a new bird to the library",
  "type": "object",
  "required": [
    "name",
    "family",
    "continents",
    "id",
    "added",
    "visible"
  ],
  "additionalProperties": false,
  "properties": {
    "name": {
      "type": "string",
      "description": "English bird name"
    },
    "family": {
      "type": "string",
      "description": "Latin bird family name"
    },
    "continents": {
      "type": "array",
      "description": "Continents the bird exist on",
      "minItems": 1,
      "items": {
        "type": "string"
      },
      "uniqueItems": true
    },
    "id": {
      "type": "string",
      "description": "5925c2251ba54f165724d826"
    }
  },
  "added": {
    "type": "String",
    "description": "2017-05-24T00:00:00.000Z"
  },
  "visible": {
    "type": false,
    "description": ""
  },
  "status": 200
}
````
`get-birds-id-response.json`.

Delete bird by id
-----------------

### Request `DELETE /birds/5925c2251ba54f165724d826}`

Empty body

### Response

````ruby
{
  "message": "Bird has been deleted Successfully!",
  "status": 200
}
````
