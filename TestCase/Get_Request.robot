*** Settings ***
# we add necessary libray
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary
*** Variables ***
${baseUrl}      https://restcountries.com

*** Test Cases ***
GetAllCountries
    create session    Get_session   ${baseUrl}
    ${response}=    get request     Get_session     /v3.1/alpha/IN
    ${status_code}=     convert to string       ${response.status_code}
    log to console      ${status_code}
    status should be      200   ${response}
    ${body}=    to json     ${response.content}
    log to console  ${body}
    ${country_name}=    get value from json      ${body}     $..name.common
    ${country_name_type}=   Evaluate  type(${country_name}).__name__
    log to console      ${country_name[0]}
    Log To Console      ${country_name_type}
    should be equal     ${country_name[0]}      India
    should be equal as strings  ${country_name[0]}  India


