*** Settings ***
Documentation    TestDemonstrarion
Library    SeleniumLibrary
Test Setup        Open the url
Test Teardown         Close Browser
Resource        resource.robot


*** Variables ***
${time}    10s
${user}    Demo12
${pass}    Test123456$


*** Test Cases ***
Elearningwebsite
    ItLearn360 Login code        ${user}        ${pass}

*** Keywords ***
ItLearn360 Login code
  [Arguments]        ${user}        ${pass}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${time}
    Click Element   css=a[href="/login"]
    Input Text    id:loginPassword    ${pass}
    Input Text    id:loginEmail    ${user}
    Click Element    css=button.platformLoginButton

    ${alllinks}=    get element count        xpath://a
    Log To Console    ${alllinks}
