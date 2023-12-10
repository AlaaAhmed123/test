*** Settings ***
Library         REST    https://jsonplaceholder.typicode.com


*** Variables ***
${json}         { "id": 11, "name": "Gil Alexander" }
&{dict}         name=Julie Langford


*** Test Cases ***
GET an existing user, notice how the schema gets more accurate
    GET         /users/1                  # this creates a new instance
    Output schema   response body
    Object      response body             # values are fully optional
    Integer     response body id          1
    String      response body name        Leanne Graham
    [Teardown]  Output schema             # note the updated response schema

GET existing users, use JSONPath for very short but powerful queries
    GET         /users?_limit=5           # further assertions are to this
    Array       response body
    Integer     $[0].id                   1           # first id is 1
    String      $[0]..lat                 -37.3159    # any matching child
    Integer     $..id                     maximum=5   # multiple matches
    [Teardown]  Output  $[*].email        # outputs all emails as an array

POST with valid params to create a new user, can be output to a file
    POST        /users                    ${json}
    Integer     response status           201
    [Teardown]  Output  response body     ${OUTPUTDIR}/new_user.demo.json

PUT with valid params to update the existing user, values matter here
    PUT         /users/2                  { "isCoding": true }
    Boolean     response body isCoding    true
    PUT         /users/2                  { "sleep": null }
    Null        response body sleep
    PUT         /users/2                  { "pockets": "", "money": 0.02 }
    String      response body pockets     ${EMPTY}
    Number      response body money       0.02
    Missing     response body moving      # fails if property moving exists

PATCH with valid params, reusing response properties as a new payload
    &{res}=     GET   /users/3
    String      $.name                    Clementine Bauch
    PATCH       /users/4                  { "name": "${res.body['name']}" }
    String      $.name                    Clementine Bauch
    PATCH       /users/5                  ${dict}
    String      $.name                    ${dict.name}

DELETE the existing successfully, save the history of all requests
    DELETE      /users/6                  # status can be any of the below
    Integer     response status           200    202     204
    Rest instances  ${OUTPUTDIR}/all.demo.json  # all the instances so far