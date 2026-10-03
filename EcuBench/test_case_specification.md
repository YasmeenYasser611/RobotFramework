# Test case specification: ECU voltage flags in CAN frame 0x123

## Assumptions (to confirm with the requirements engineer)
- ECU voltage resolution is 0.1 V (the step size around each boundary follows the ECU resolution, not the power supply).
- 5.0 V is undervoltage; 9.0 V and 14.0 V are normal; 18.0 V is overvoltage (the requirement table overlaps at these points).
- Byte 4 is `frame[3]` (bytes numbered from 1). Overvoltage flag = Byte 4, Bit 1, mask `0x02`. Undervoltage flag = Byte 4, Bit 5, mask `0x10`.
- Open point: `0x02` counts bits from 0 but `0x10` counts from 1. Ask which bit is the first one (if Bit 5 counted from 0, the mask would be `0x20`).
- Voltages below 5 V and above 18 V are never applied to the ECU (shutdown / damage).

## Open questions
1. ECU voltage resolution and tolerance of the supply reading?
2. Which range owns exactly 9 V and 14 V? Is 5 V and 18 V inclusive?
3. DLC and cycle time of frame 0x123? Reaction time of the flags after a voltage change?
4. Hysteresis when returning to normal?
5. Meaning of the other bits in Byte 4?
6. Bit numbering (see above).

## Common preconditions
- ECU, adjustable power supply and CAN interface are available and undamaged.
- Power supply output is OFF and set to 0 V.
- Test PC with the team framework (`Set_Supply_Voltage`, `Get_Frame_Data`) is connected to the CAN interface.
- ECU is not yet connected to anything.

---

## TC-ID 001: Undervoltage at 5.0 V (Lower valid limit)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(5.0)` (turns the output ON) | Display shows 5.0 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 5.0 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0x10 (Undervoltage flag, Bit 5, SET) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 1.

---

## TC-ID 002: Undervoltage at 5.1 V (Just inside lower limit)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(5.1)` (turns the output ON) | Display shows 5.1 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 5.1 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0x10 (Undervoltage flag, Bit 5, SET) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 1.

---

## TC-ID 003: Undervoltage at 7.0 V (Mid undervoltage)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(7.0)` (turns the output ON) | Display shows 7.0 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 7.0 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0x10 (Undervoltage flag, Bit 5, SET) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 1.

---

## TC-ID 004: Undervoltage at 8.9 V (Just below 9 V)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(8.9)` (turns the output ON) | Display shows 8.9 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 8.9 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0x10 (Undervoltage flag, Bit 5, SET) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 1.

---

## TC-ID 005: Normal operation at 9.0 V (Boundary 9 V (assumed normal))

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(9.0)` (turns the output ON) | Display shows 9.0 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 9.0 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 006: Normal operation at 9.1 V (Just above 9 V)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(9.1)` (turns the output ON) | Display shows 9.1 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 9.1 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 007: Normal operation at 11.5 V (Mid normal)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(11.5)` (turns the output ON) | Display shows 11.5 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 11.5 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 008: Normal operation at 13.9 V (Just below 14 V)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(13.9)` (turns the output ON) | Display shows 13.9 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 13.9 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 009: Normal operation at 14.0 V (Boundary 14 V (assumed normal))

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(14.0)` (turns the output ON) | Display shows 14.0 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 14.0 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0 (Overvoltage flag, Bit 1, cleared); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 0, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 010: Overvoltage at 14.1 V (Just above 14 V)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(14.1)` (turns the output ON) | Display shows 14.1 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 14.1 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0x02 (Overvoltage flag, Bit 1, SET); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 1, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 011: Overvoltage at 16.0 V (Mid overvoltage)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(16.0)` (turns the output ON) | Display shows 16.0 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 16.0 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0x02 (Overvoltage flag, Bit 1, SET); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 1, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 012: Overvoltage at 17.9 V (Just below 18 V)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(17.9)` (turns the output ON) | Display shows 17.9 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 17.9 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0x02 (Overvoltage flag, Bit 1, SET); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 1, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 013: Overvoltage at 18.0 V (Upper valid limit 18 V)

**Preconditions:** see common preconditions above.

| Step | Action | Expected result |
|---|---|---|
| 1 | Check the power supply display | Output is OFF and the display shows 0 V |
| 2 | Connect the ECU power input to the supply, correct polarity | Nothing - no change (output still OFF, 0 V) |
| 3 | Connect the CAN interface to the ECU CAN connector | Nothing - no change (no frames received, no error reported) |
| 4 | `Set_Supply_Voltage(18.0)` (turns the output ON) | Display shows 18.0 V (tolerance to be confirmed) and the ECU powers up |
| 5 | Wait one frame cycle (period to be confirmed) | Voltage stays at 18.0 V |
| 6 | `Get_Frame_Data(0x123)` | A frame with ID 0x123 is returned, at least 4 bytes long, no timeout |
| 7 | Read Byte 4 (`frame[3]`) and apply the masks | `Byte 4 & 0x02` = 0x02 (Overvoltage flag, Bit 1, SET); `Byte 4 & 0x10` = 0 (Undervoltage flag, Bit 5, cleared) |
| 8 | `Set_Supply_Voltage(0)`, then disconnect | Display shows 0 V and no more frames are received |

**Pass criteria:** frame ID is 0x123, Overvoltage flag (Byte 4, Bit 1) = 1, Undervoltage flag (Byte 4, Bit 5) = 0.

---

## TC-ID 014: Unsafe voltages are refused (4.9 V and 18.1 V)

Not executed on the ECU: below 5 V the ECU shuts down and above 18 V it is damaged.

| Step | Action | Expected result |
|---|---|---|
| 1 | Prepare the bench as in the common preconditions | Output OFF, 0 V displayed |
| 2 | Request `Set_Supply_Voltage(4.9)` | The request is refused (UNSAFE error) and the supply stays at 0 V |
| 3 | Request `Set_Supply_Voltage(18.1)` | The request is refused (UNSAFE error) and the supply stays at 0 V |

**Pass criteria:** neither voltage is applied to the ECU.
**Note:** only valid if the team's bench or framework has a voltage limit. If it does not, do not run this case and escalate to the team lead / requirements engineer.
