*** Settings ***
Documentation        Test Case to execute the login process
Library        SeleniumLibrary


*** Variables ***
${url}    https://www.itlearn360.com/
${browser}    chrome



*** Keywords ***
Open the url
    Open Browser    ${url}    ${browser}