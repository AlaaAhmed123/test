*** Settings ***
# we add necessary libray
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary
Library    String
Resource    ../Resources/common.robot


*** Test Cases ***
Employee
    LoginEmployee
    GetGroupItemsEmployee
    GetItemQuestionsEmployee
    SaveEvaluationEmployee
    LogoutEmployee
