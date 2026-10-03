*** Settings ***
Library          CanSim.py
Test Setup       Connect Virtual Bus
Test Teardown    Disconnect

*** Test Cases ***
Frame Is Received Correctly
    [Tags]    smoke
    Send Frame    0x123    0x11    0x22    0x33
    ${msg}=    Receive Frame    timeout=1
    Frame Id Should Be      ${msg}    0x123
    Frame Data Should Be    ${msg}    0x11    0x22    0x33

Receive Fails When Nothing Is Sent
    Run Keyword And Expect Error    No CAN frame received
    ...    Receive Frame   timeout=0.5