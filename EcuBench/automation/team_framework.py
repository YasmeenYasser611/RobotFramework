_supply = {"volts": None}


def Set_Supply_Voltage(v):
    v = float(v)
    if not 5.0 <= v <= 18.0:
        raise AssertionError(
            f"UNSAFE: {v} V is outside 5-18 V. Not applied. "
            "Escalate to the requirements engineer."
        )
    _supply["volts"] = v


def Get_Frame_Data(frame_id):
    if int(str(frame_id), 0) != 0x123:
        raise AssertionError(f"Frame {frame_id} not available")
    v = _supply["volts"]
    if v is None:
        raise AssertionError("No supply voltage set")
    frame = [0] * 8
    if 5.0 <= v < 9.0:
        frame[3] |= 0x10      # undervoltage flag, Byte 4
    elif 14.0 < v <= 18.0:
        frame[3] |= 0x02      # overvoltage flag, Byte 4
    return frame
