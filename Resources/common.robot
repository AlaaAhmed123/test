*** Settings ***
# we add necessary libray
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary
Library    String

*** Variables ***
#This is our base url for api testing
${baseUrl}  https://web.v-dream.net/api

# and this is end point too
${Login}     /ToolSetting/Login
${emp}      /EmployeeQR/Login
${GetGroupItems}    /EmployeeQR/GetGroupItems
${GetEvaluationLink}    /GetEvaluationLink
${GetItemQuestions}     /EmployeeQR/GetItemQuestions
${SaveEvaluation}       /EmployeeQR/SaveEvaluation
${Logout}   /EmployeeQR/Logout
*** Variables ***
${data}
${token}
${refreshToken}
${id}
${templateId}
${empId}
${companyId}
${brnEmpId}
${EvaluatedId}
@{QuestionAnswer}
*** Keywords ***
Login
    create session    Login_session  ${baseUrl}
    ${body}=    create dictionary          Email=test28_11@teml.net   Password=Alaa#1122
    ${header}=  create dictionary    Content-Type=application/json
    ${response}=    requestslibrary.post request    Login_session    ${Login}     data=${body}     headers=${header}
    Status Should Be                 200  ${response}
    Dictionary Should Contain Key    ${response.json()}  data
    ${data}=	convert to string    	${response.json()}[data]
    ${Token}=   split string    ${data}   ,
    ${token_data}=  get substring   ${Token}[2]  9  -1
    [Return]    ${token_data}
LoginEmployee
    create session    LoginEmployee  ${baseUrl}
    ${body}=    create dictionary          DeviceId=RTXD-539573  Password=Alaa#1122     UserName=dm22
    ${header}=  create dictionary    Content-Type=application/json
    ${response}=    requestslibrary.post request    LoginEmployee    ${emp}     data=${body}     headers=${header}
    Status Should Be    200  ${response}
    Dictionary Should Contain Key    ${response.json()}  data
    ${body}=	to json    	${response.content}
    #log to console    ${body}
    #${Token}=   split string    ${data}   ,
    #${token_data}=  get substring   ${Token}[2]  9  -1
     Set Global Variable    ${data}    ${body}
     ${BrnEmpId}=   get value from json    ${body}  $..data.brnEmpId
     set global variable    ${brnEmpId}     ${BrnEmpId}[0]
     ${emp_ID}=     get value from json    ${body}  $..data.empId
     set global variable      ${empId}      ${emp_ID}
     ${companyID}=      get value from json    ${body}  $..data.companyId
     set global variable         ${companyId}       ${companyID}[0]
     ${token_data}=   get value from json      ${data}     $..data.token
     set global variable    ${token}    ${token_data}[0]
     ${refresh_Token}   get value from json      ${data}     $..data.refreshToken
     set global variable    ${refreshToken}    ${refresh_Token}[0]
GetGroupItemsEmployee
    create session    GetGroupItemsEmployee  ${baseUrl}
    ${body}=    create dictionary   EvaluatorEnumId=4  Language=5   RefreshToken=${refreshToken}
    ${header}=  create dictionary    Authorization=${token}     Content-Type=application/json
    ${response}=    requestslibrary.post request    GetGroupItemsEmployee    ${getgroupitems}    data=${body}     headers=${header}
    Status Should Be    200  ${response}
    ${body}=	to json    	${response.content}
    ${ItemId}=        get value from json      ${body}     $..data.objectList[0].id
    set global variable     ${id}    ${ItemId}[0]
    ${templateID}=    get value from json   ${body}    $..data.objectList[0].templateId
    set global variable     ${templateId}        ${templateID}[0]
GetItemQuestionsEmployee
    create session    GetItemQuestionsEmployee  ${baseUrl}
    ${body}=    create dictionary   CompanyId=${companyId}    EmployeeId=${empId}[0]      ItemId=${id}   TemplateId=${templateId}     LanguageId=5   RefreshToken=${refreshToken}
    ${header}=  create dictionary    Authorization=${token}     Content-Type=application/json
    ${response}=    requestslibrary.post request    GetItemQuestionsEmployee    ${GetItemQuestions}    data=${body}     headers=${header}
    Status Should Be    200  ${response}
    ${body}=	to json    ${response.content}
    @{itemQuestions}=   get value from json    ${body}      $..data.itemQuestions
    ${count}=   Get Length      @{itemQuestions}
    @{Question_Answer}  create list
    FOR    ${i}     IN RANGE   ${count}
        ${evaluationQuestionId}=    get value from json    ${body}      $..data.itemQuestions[${i}].evaluationQuestionId
        ${answerId}=    get value from json     ${body}     $..data.itemQuestions[${i}].evaluationAnswers[0].answerId
        ${x}=	Create Dictionary   QuestionId=${evaluationQuestionId}[0]    AnswerId=${answerId}[0]
        append to list    ${Question_Answer}  ${x}
        #log to console      ${Question_Answer}
    END
    set global variable     @{QuestionAnswer}   @{Question_Answer}
    log to console      ${QuestionAnswer}
SaveEvaluationEmployee
    log to console    ${brnEmpId}
    log to console    ${id}
    log to console    ${empId}[0]
    log to console    ${QuestionAnswer}
    log to console    ${refreshToken}
    create session    SaveEvaluationEmployee  ${baseUrl}
    ${body}=    create dictionary   EvaluatorId=${brnEmpId}    EvaluatedId=${id}   EmployeeId=${empId}[0]  QuestionAnswer=@{QuestionAnswer}   LanguageId=5   RefreshToken=${refreshToken}
    ${header}=  create dictionary    Authorization=${token}     Content-Type=application/json
    ${response}=    requestslibrary.post request    SaveEvaluationEmployee    ${SaveEvaluation}    data=${body}     headers=${header}
    Status Should Be    200  ${response}
    ${body}=	to json    	${response.content}
    log to console    ${body}

LogoutEmployee
    #${token}=    get value from json      ${data}     $..data.token
    #${token_data}=       get substring   ${Token}[0]  8    52
    create session    LogoutEmployee  ${baseUrl}
    ${body}=    create dictionary          LangId=5  Password=Alaa#1122
    ${header}=  create dictionary    Authorization=${token}     Content-Type=application/json
    ${response}=    requestslibrary.post request    LogoutEmployee    ${Logout}     data=${body}     headers=${header}
    Status Should Be    200  ${response}
    Dictionary Should Contain Key    ${response.json()}  message
    dictionary should contain value   ${response.json()}     تم تسجيل الخروج بنجاح
LoginHotel
    log to console  LoginHotel
    input text     name:deviceId       RTXD-712744
    input text     name:userName       br22
    input text     name:password       Alaa#1122
    click element    xpath://*[@id="root"]/div/div[2]/div/div[2]/form/div[4]/button
    sleep    10
    ${Status}=     Run Keyword And Return Status    element should be visible     xpath:/html[1]/body[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/p[1]
    log to console  ${Status}
    IF      ${Status} == True
        log to console  ${Status}
        sleep    5
        click element    class:Login_Logout__otfFB
        sleep    5
        input text    name:Password     Alaa#1122
        click element    xpath:/html/body/div[3]/div/div/form/div[3]/button[1]
        sleep    5
        input text     name:deviceId       RTXD-712744
        input text     name:userName       br22
        input text     name:password       Alaa#1122
        click element    xpath://*[@id="root"]/div/div[2]/div/div[2]/form/div[4]/button
    END
    sleep    10
    Press Keys    None    ESC
    ${input_value1}=   get text    xpath://*[@id="root"]/div/div[2]/div/div[1]/div[3]/div[1]/p[1]
    log to console  ${input_value1}
    ${input_value2}=   get text    xpath://*[@id="root"]/div/div[2]/div/div[1]/div[3]/div[1]/p[2]
    log to console  ${input_value2}
    ${input_value3}=   get text    xpath://*[@id="LanPage"]/p
    log to console  ${input_value3}
    ${input_value4}=   get text    xpath://*[@id="LanPage"]/div[1]/button
    log to console  ${input_value4}
    ${input_value5}=   get text    xpath://*[@id="LanPage"]/div[2]/button
    log to console  ${input_value5}
    ${input_value6}=   get text    xpath: //*[@id="root"]/div/div[2]/div/div[2]/div
    log to console  ${input_value6}
LogoutHotel
    log to console  LogoutHotel
    sleep    10
    Press Keys    None    ESC
    click element    xpath:/html[1]/body[1]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/div[1]/*[name()='svg'][1]
    sleep    5
    input text    name:Password     Alaa#1122
    click element    xpath://*[@id="Modal"]/div/form/div[3]/button[1]
ChooseService
    log to console    ChooseService
    click element    xpath:/html/body/div/div/div[2]/div/div[1]/div[3]/div[2]/div[1]/button
    sleep    10
    ${input_value1}=   get text    xpath://*[@id="root"]/div/div[2]/div/div[1]/div[3]/div[1]/p[1]
    log to console  ${input_value1}
    ${input_value2}=   get text    xpath://*[@id="root"]/div/div[2]/div/div[1]/div[3]/div[1]/p[2]
    log to console  ${input_value2}
    ${input_value3}=    get text    xpath://*[@id="ServicePage"]/div/p
    log to console  ${input_value3}
    ${services}=    get webelements    class:Welcome_LanBtn__tk4JV
    ${count}=   get length    ${services}
    log to console  ${count}
    IF  ${count} != 2
        click element    xpath://*[@id="ServicePage"]/div/div/div[1]
    ELSE
        click element    xpath://*[@id="ServicePage"]/div/div/div
    END
AnswerQuestion
        sleep    10
        ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         log to console  ${Status}
         WHILE  ${Status} == True  limit=NONE
                log to console  ${Status}
                Wait Until Element Is Visible   xpath:/html[1]/body[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[2]/div[2]/div[1]/span[1]/span[1]/span[2]/*[name()='svg'][1]/*[name()='path'][1]
                Click Element    xpath:/html[1]/body[1]/div[1]/div[1]/div[1]/div[3]/div[1]/div[2]/div[2]/div[1]/span[1]/span[1]/span[2]/*[name()='svg'][1]/*[name()='path'][1]
                sleep    5
                ${Status}=     Run Keyword And Return Status    element should be disabled    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         END
         sleep    5
         click element    xpath://*[@id="root"]/div/div/div[3]/div/div[3]/button
         sleep    5
         click element    xpath://*[@id="Modal"]/div/div/div[2]/div[2]
         sleep    10






