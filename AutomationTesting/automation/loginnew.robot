*** Settings ***
Documentation    TestDemonstrarion
Library    SeleniumLibrary
Resource        resource.robot
Test Setup        Open the url
Test Teardown         Close Browser
Test Template         ItLearn360 Login code


*** Variables ***
${time}    10s
${user}    Demo12
${pass}    Test123456$


*** Test Cases ***
                                        username                     password
Invalid username                        Demo1234                     Test123456$
Invalid password                        Demo12                       Test12344454
Invalid characters                      abc@#                        Test123456$

*** Keywords ***
ItLearn360 Login code
  [Arguments]        ${username}        ${password}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${time}
    Click Element   css=a[href="/login"]
    Input Text    id:loginPassword    ${password}
    Input Text    id:loginEmail    ${username}
    Click Element    css=button.platformLoginButton

    ${alllinks}=    get element count        xpath://a
    Log To Console    ${alllinks}
