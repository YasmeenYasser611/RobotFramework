*** Settings ***
Documentation    Task 2: flags in CAN frame 0x123, Byte 4, checked with bit masks.
...              CONVENTIONS (to confirm): Byte 4 = index 3 (bytes numbered from 1);
...              Overvoltage mask 0x02 (Bit 1); Undervoltage mask 0x10 (Bit 5),
...              as given in the interview. Note: 0x02 counts bits from 0 but 0x10
...              counts from 1 - ask which bit is the first one.
Library          team_framework.py
Test Template    Flags Should Match Voltage

*** Variables ***
${FRAME_ID}       ${0x123}
${BYTE4_INDEX}    ${3}
${OV_MASK}        ${0x02}
${UV_MASK}        ${0x10}

*** Test Cases ***                  VOLTS    UV    OV
TC001 Lower valid limit             5.0      1     0
TC002 Just inside                   5.1      1     0
TC003 Mid undervoltage              7.0      1     0
TC004 Just below 9 V                8.9      1     0
TC005 Boundary 9 V                  9.0      0     0
TC006 Just above 9 V                9.1      0     0
TC007 Mid normal                    11.5     0     0
TC008 Just below 14 V               13.9     0     0
TC009 Boundary 14 V                 14.0     0     0
TC010 Just above 14 V               14.1     0     1
TC011 Mid overvoltage               16.0     0     1
TC012 Just below 18 V               17.9     0     1
TC013 Upper valid limit 18 V        18.0     0     1

TC014 Bench refuses unsafe voltages
    [Template]    NONE
    Run Keyword And Expect Error    UNSAFE*    Set Supply Voltage    4.9
    Run Keyword And Expect Error    UNSAFE*    Set Supply Voltage    18.1

*** Keywords ***
Flags Should Match Voltage
    [Arguments]    ${volts}    ${exp_uv}    ${exp_ov}
    Set Supply Voltage    ${volts}
    ${frame}=    Get Frame Data    ${FRAME_ID}
    ${len}=      Get Length    ${frame}
    Should Be True    ${len} > ${BYTE4_INDEX}    Frame too short: ${len} bytes
    ${b4}=    Set Variable    ${frame}[${BYTE4_INDEX}]
    ${ov}=    Evaluate    int((${b4} & ${OV_MASK}) != 0)
    ${uv}=    Evaluate    int((${b4} & ${UV_MASK}) != 0)
    Should Be Equal As Integers    ${ov}    ${exp_ov}    Overvoltage flag wrong at ${volts} V (Byte 4 = ${b4})
    Should Be Equal As Integers    ${uv}    ${exp_uv}    Undervoltage flag wrong at ${volts} V (Byte 4 = ${b4})
