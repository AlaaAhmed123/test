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
${baseUrl}  https://web.v-dream.net/api/ToolSetting
# and this is end point too
${Login}     /Login
${GetEvaluationLink}    /GetEvaluationLink

*** Test Cases ***
GetLink
    #log to console    ${Token}[2]
    ${token_data}=   Login
    # log to console    ${token_data}
    ${headers}=  create dictionary    Authorization=Bearer ${token_data}   Content-Type=application/json
    ${data}=     create dictionary      DeviceId=501    EmpId=95c93815-bb9c-4497-a4df-c11d3824e586   PhoneNumber=4567905   Email=KA4567905@test.com"    BillNumber=KA4567905  ProductsIds=95c93673-9006-4196-b868-672b0990e7cc,9627f88c-7428-423b-956a-48a8bb63e4b6  IntegrationId=1   TypeId=1
    create session    GetEvaluationLink     ${baseUrl}
    ${resp}=    requestslibrary.post request     GetEvaluationLink   ${GetEvaluationLink}    data=${data}    headers=${headers}
    Status Should Be    200  ${resp}
    ${Link}=   split string    ${resp.json()}[data][evaluationLink]    ,
    log to console  ${Link}[1]
    Open Browser    ${Link}[1]  edge
    Maximize Browser Window
    wait until element is visible    xpath://*[@id="root"]/div/div/div/div[1]/div[1]/p
    page should contain element    xpath://*[@id="root"]/div/div/div/div[1]/div[1]/div[1]/p[1]
    ${CompanyName}=     get text    xpath://*[@id="root"]/div/div/div/div[1]/div[1]/div[1]/p[1]
    log to console      ${CompanyName}
    page should contain element    xpath://*[@id="root"]/div/div/div/div[1]/div[1]/div[1]/p[2]
    ${branchName}=      get text    xpath://*[@id="root"]/div/div/div/div[1]/div[1]/div[1]/p[2]
    log to console      ${branchName}
    click element    xpath://*[@id="root"]/div/div/div/div[1]/div[1]/div[2]/div[2]/a
    sleep    7
    ${elements}=    Get WebElements    class:EvaluationType_EVbtn__znf7A
    ${count}=   get length    ${elements}
    log to console    ${count}
    WHILE   ${count}>=1
       log to console    ${count}
       ${group}=   get text    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${count}]/div/div/p
       log to console   ${group}
       WHILE    '${group}' == 'Product'
         log to console  ${group}
         click element    xpath://p[contains(.,'${group}')]
         sleep    10
         ${Products}=    Get WebElements    class:Items_Card__FNOgh
         ${Product_count}=   get length    ${Products}
         log to console  ${Product_count}
         IF  ${Product_count} == 1
                log to console  ${Product_count}
                ${Product}=   get text    xpath://*[@id="root"]/div/div/div[2]/div/div/div/p
                log to console    ${Product}
                click element    xpath://*[@id="root"]/div/div/div[2]/div/div/div/p
         ELSE
                log to console  ${Product_count}
                ${Product}=   get text    xpath://*[@id="root"]/div/div/div[2]/div/div[${Product_count}]/div/p
                log to console    ${Product}
                click element    xpath://*[@id="root"]/div/div/div[2]/div/div[${Product_count}]/div/p
                ${Product_count}=   Evaluate    ${Product_count} - 1
         END
         sleep    10
         ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         log to console  ${Status}
         WHILE      '${Status}'=='True'  limit=NONE
                log to console  ${Status}
                click element    xpath://*[@id="root"]/div/div/div[3]/div/div[2]/div[2]/div[2]/div/p
                sleep    5
                ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         END
         sleep    5
         execute javascript    window.scrollTo(0, document.body.scrollHeight)
         click element    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         sleep    5
         click element    xpath://*[@id="Modal"]/div/div/div[2]/div[1]
         sleep    15
         log to console    alaaahmed
         IF  ${Product_count} != 1
            wait until element is visible    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${count}]/div/div/p
            ${group}=   get text    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${count}]/div/div/p
         ELSE IF    ${Product_count} == 1
              ${i}=     evaluate    ${count} - ${1}
              ${group}=   get text    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${i}]/div/div/p
         END

       END
       IF    '${group}' == 'employee'
         log to console  ${group}
         click element    xpath://p[contains(.,'${group}')]
         sleep    10
         ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         log to console  ${Status}
         WHILE      '${Status}'=='True'  limit=NONE
                log to console  ${Status}
                click element    xpath://*[@id="root"]/div/div/div[3]/div/div[2]/div[2]/div[2]/div/p
                sleep    5
                ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         END
         execute javascript    window.scrollTo(0, document.body.scrollHeight)
         sleep    5
         click element    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         sleep    5
         click element    xpath://*[@id="Modal"]/div/div/div[2]/div[1]
         sleep    10
         log to console    alaaahmed
       ELSE IF   '${group}' == 'Branch evaluation'
            log to console  ${group}
         click element    xpath://p[contains(.,'${group}')]
         sleep    10
         ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         log to console  ${Status}
         WHILE      '${Status}'=='True'  limit=NONE
                log to console  ${Status}
                click element    xpath://*[@id="root"]/div/div/div[3]/div/div[2]/div[2]/div[1]/div/p
                sleep    5
                ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         END
         sleep    5
         click element    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         sleep    5
         click element    xpath://*[@id="Modal"]/div/div/div[2]/div[1]
         sleep    10
         log to console    alaaahmed

       END
       WHILE    '${group}' == 'Management evaluation'
         log to console  ${group}
         click element    xpath://p[contains(.,'${group}')]
         sleep    5
         ${administrations}=    Get WebElements    class:Items_Card__FNOgh
         ${administration_count}=   get length    ${administrations}
         log to console  ${administration_count}
         IF  ${administration_count} == 1
                log to console  ${administration_count}
                ${administration}=   get text    xpath://*[@id="root"]/div/div/div[2]/div/div/div/p
                log to console    ${administration}
                click element    xpath://*[@id="root"]/div/div/div[2]/div/div/div/p
         ELSE
                log to console  ${administration_count}
                ${administration}=   get text    xpath://*[@id="root"]/div/div/div[2]/div/div[${administration_count}]/div/p
                log to console    ${administration}
                click element    xpath://*[@id="root"]/div/div/div[2]/div/div[${administration_count}]/div/p
                ${administration_count}=   Evaluate    ${administration_count} - 1
         END
         sleep    10
         ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         log to console  ${Status}
         WHILE      '${Status}'=='True'  limit=NONE
                log to console  ${Status}
                click element    xpath://*[@id="root"]/div/div/div[3]/div/div[2]/div[2]/div[2]/div/p
                sleep    5
                ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         END
         sleep    5
         click element    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         sleep    5
         click element    xpath://*[@id="Modal"]/div/div/div[2]/div[1]
         sleep    15
         log to console    alaaahmed
         IF  ${administration_count} != 1
            wait until element is visible    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${count}]/div/div/p
            ${group}=   get text    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${count}]/div/div/p
         ELSE IF    ${administration_count} == 1
              ${i}=     evaluate    ${count} - ${1}
              ${group}=   get text    xpath://*[@id="root"]/div/div/div/div[2]/div[2]/div/div[${i}]/div/div/p
         END

       END
       sleep    10
       ${count}=    evaluate    ${count} - 1
    END
    sleep    10
