*** Settings ***
Library    SeleniumLibrary

*** Variables ***

*** Test Cases ***
AmazonWebsite
    Open Browser    https://www.amazon.com    chrome
    Sleep     5s
    Close Browser

*** Keywords ***


