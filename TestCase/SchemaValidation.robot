*** Settings ***
Library  JSONSchemaLibrary

*** Variables ***
@{list_of_dicts}    Id:${1}    Name:value2    Status:Active, Id:${1}    Name:value2    Status:Active
&{dict1}    Id=${1}    Name=value2    Status=Active
&{dict2}    Id=${1}    Name=value2    Status=Active
@{list_of_dicts1}    ${dict1}    ${dict2}
*** Test Cases ***
JSON Validation
  log to console    ${list_of_dicts}
  log to console    ${list_of_dicts1}
  Validate Json  test.schema.json  ${list_of_dicts1}