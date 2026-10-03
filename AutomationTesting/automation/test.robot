*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Elearningwebsite
    Open Browser    https://www.itlearn360.com/    chrome
    Maximize Browser Window
    Set Selenium Implicit Wait    10s
    Click Element   css=a[href="/login"]
    Input Text    id:loginEmail   Demo12
    Input Text    id:loginPassword    Test123456$
    Click Element    css=button.platformLoginButton