"""Plain-Python version of the interview exercise (bit masking).

Uses the team's functions Set_Supply_Voltage(v) and Get_Frame_Data(id).
Run it here against the stand-in:  python3 flag_check.py
"""
from team_framework import Set_Supply_Voltage, Get_Frame_Data

BYTE4_INDEX = 3      # Byte 4, bytes numbered from 1
OV_MASK = 0x02       # Overvoltage flag, Bit 1
UV_MASK = 0x10       # Undervoltage flag, Bit 5 (confirm the bit numbering)


def check_flags(v, expect_uv, expect_ov):
    Set_Supply_Voltage(v)
    frame = Get_Frame_Data(0x123)

    assert len(frame) > BYTE4_INDEX, f"Frame 0x123 too short: {len(frame)} bytes"
    b4 = frame[BYTE4_INDEX]

    ov_set = (b4 & OV_MASK) != 0
    uv_set = (b4 & UV_MASK) != 0

    assert ov_set == bool(expect_ov), f"{v} V: Overvoltage flag wrong, Byte 4 = {b4:#04x}"
    assert uv_set == bool(expect_uv), f"{v} V: Undervoltage flag wrong, Byte 4 = {b4:#04x}"
    print(f"PASS  {v:>5} V  Byte 4 = {b4:#04x}  UV={int(uv_set)} OV={int(ov_set)}")


if __name__ == "__main__":
    check_flags(9.0, expect_uv=0, expect_ov=0)    # normal
    check_flags(8.0, expect_uv=1, expect_ov=0)    # undervoltage
    check_flags(16.0, expect_uv=0, expect_ov=1)   # overvoltage
