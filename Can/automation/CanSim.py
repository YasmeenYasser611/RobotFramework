import can
class CanSim:
    ROBOT_LIBRARY_SCOPE = "TEST"

    def __init__(self):
        self.tx = None
        self.rx = None

    def connect_virtual_bus(self, channel="test_bus"):
        self.tx = can.Bus(interface="virtual",channel=channel)
        self.rx = can.Bus(interface="virtual", channel=channel)

    def send_frame(self, can_id, *data):
        msg = can.Message(
            arbitration_id=int(str(can_id), 0),
            data=[int(str(b), 0) for b in data],
            is_extended_id=False,
        )
        self.tx.send(msg)

    def receive_frame(self, timeout=1):
        msg = self.rx.recv(float(timeout))
        if msg is None:
            raise AssertionError("No CAN frame received")
        return msg

    def frame_id_should_be(self, msg, expected):
        if msg.arbitration_id != int(str(expected), 0):
            raise AssertionError(
                f"Expected ID {expected}, got {hex(msg.arbitration_id)}"
            )

    def frame_data_should_be(self, msg, *expected):
        want = [int(str(b), 0) for b in expected]
        if list(msg.data) != want:
            raise AssertionError(f"Expected {want}, got {list(msg.data)}")

    def disconnect(self):
        for bus in (self.tx, self.rx):
            if bus:
                bus.shutdown()