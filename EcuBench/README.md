# ECU voltage flags: Robot Framework tests

Two tasks, one project.

| File | What it is |
|---|---|
| `ecu_voltage_alone.robot` | Task 1: 14 BVA test cases on the voltage ranges (behaviour only, no CAN) |
| `ecu_can_flags.robot` | Task 2: the same cases checked in CAN frame 0x123, Byte 4, with bit masks |
| `team_framework.py` | Stand-in for the team's `Set_Supply_Voltage(v)` and `Get_Frame_Data(id)` |
| `flag_check.py` | Plain-Python bit-masking version of the exercise |
| `test_case_specification.md` | Written test cases: preconditions, steps, expected results, pass criteria |


## Requirements traceability

| Requirement | Description | Test cases | Status |
|---|---|---|---|
| REQ-01 | 9 to 14 V: normal operation | TC05 to TC09 | Covered |
| REQ-02 | 14 to 18 V: overvoltage flag | TC10 to TC13 | Covered |
| REQ-03 | 5 to 9 V: undervoltage flag | TC01 to TC04 | Covered |
| REQ-04 | Below 5 V: ECU shuts down | TC14 (bench refuses the voltage) | Not run on ECU (unsafe) |
| REQ-05 | Above 18 V: ECU is damaged | TC14 (bench refuses the voltage) | Not run on ECU (unsafe) |
| REQ-06 | Frame 0x123: Overvoltage flag in Byte 4 Bit 1, Undervoltage flag in Byte 4 Bit 5 | `ecu_can_flags.robot` | Covered |


## Run
```bash
python3 -m venv venv
source venv/bin/activate
pip install robotframework
robot --outputdir results ecu_voltage_alone.robot ecu_can_flags.robot
python3 flag_check.py
```
Expected: 28 tests, 28 passed.

## Technique
Equivalence partitioning (undervoltage, normal, overvoltage, two invalid ranges), then boundary value analysis at 5, 9, 14 and 18 V. The step size is the ECU resolution (assumed 0.1 V). Voltages outside 5 to 18 V are never applied to the ECU.

## Assumptions and open questions
See the top of `test_case_specification.md`. The main ones: resolution, ownership of 9 V and 14 V, Byte 4 = index 3, and the bit numbering (`0x02` for Bit 1 but `0x10` for Bit 5 count differently).

## On a real bench
Replace `team_framework.py` with the team's module. Task 1's `ECU Model Reacts To` keyword is the only other stand-in. The test cases stay the same.
