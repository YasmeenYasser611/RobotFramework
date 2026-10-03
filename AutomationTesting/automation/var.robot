*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${url}    https://www.itlearn360.com/
${browser}    chrome
${time}    10s
${user}    Demo12
${pass}    Test123456$




*** Test Cases ***
Elearningwebsite
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${time}
    Click Element   css=a[href="/login"]
    Input Text    id:loginPassword    ${pass}
    Input Text    id:loginEmail    ${user}
    Click Element    css=button.platformLoginButton