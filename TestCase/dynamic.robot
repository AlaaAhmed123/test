*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary
Library    String



*** Variables ***
${git_api}     https://api.github.com
${token}    Bearer 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

*** Test Cases ***
Login1
    create session    Login_session   ${git_api}
    ${header}=  create dictionary    Content-Type=application/json  Authorization=${token}
    ${response}=    GET on session    Login_session    /users/AlaaAhmed123/repos     headers=${header}
    ${resp_data}=   To Json     ${response.content}
    log to console  ${resp_data}
    Delete All Sessions