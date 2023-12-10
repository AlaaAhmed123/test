*** Settings ***
# we add necessary libray
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary
Library    String
Resource    ../Resources/common.robot


*** Variables ***
#This is our base url for api testing
${baseUrl}  https://login.ratehex.com
*** Test Cases ***
Hotel
    log to console  Hotel
    Open Browser    ${baseUrl}  firefox
    Maximize Browser Window
    wait until element is visible    xpath://*[@id="root"]/div/div[2]/div/div[1]/p
    LoginHotel
    ChooseService
    AnswerQuestion
    LogoutHotel