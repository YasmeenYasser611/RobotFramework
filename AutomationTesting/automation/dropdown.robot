*** Settings ***
Documentation    DrobDownAlert
Library    SeleniumLibrary

*** Variables ***
${url}        https://training.qaonlinetraining.com/testPage.php
${browser}        Chrome

*** Test Cases ***
RadioButton and Button
    Perform click on Button

Dropdown elements
    select value

Alert Test
    Alert click


*** Keywords ***
Perform click on Button
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Click Element        xpath:/html/body/form/input[4]
    Click Element        xpath:/html/body/form/input[9]

select value
    Select From List By Label        country        Ethiopia
    Click Element    name:submit

Alert click
    Click Element         id:alert
    handle alert        accept
    Click Element         id:confirm
    handle alert        dismiss