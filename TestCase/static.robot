*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary
Library    String


*** Keywords ***
Login1
    create session    Login_session   ${base_api}
    ${logincreit}=    create dictionary          email=john@mail.com   password=changeme
    #${header}=  create dictionary    Authorization=${logincreit}
    ${response}=    post on session    Login_session    /v1/auth/login     json=${logincreit}
    ${resp_data}=   To Json     ${response.content}
    ${access_token}=    get value from json     ${resp_data}    $.access_token
    ${refresh_token}    get value from json     ${resp_data}    $.refresh_token
    [Return]    ${access_token}[0]
    log to console  ${refresh_token}
*** Variables ***
${base_api}    https://api.escuelajs.co/api

*** Test Cases ***

GETProfile
    ${access_token}=    Login1
    create session    get   ${base_api}
    ${header}=  create dictionary    Content-Type=application/json  Authorization=Bearer ${access_token}
    ${response}=    GET On Session  get    /v1/auth/profile     headers=${header}
    ${response_data}=   to json    ${response.content}
    log to console  ${response_data}
    Delete All Sessions
