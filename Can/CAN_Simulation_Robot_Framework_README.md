# CAN Simulation & Robot Framework Testing --- Project README

## 1. Project Purpose

This project uses:

-   **Python**
-   **python-can**
-   **Robot Framework**
-   A **virtual CAN bus**

The goal is to test CAN communication without requiring physical CAN
hardware.

The project creates a small Python library called `CanSim` and exposes
its functions as Robot Framework keywords.

The overall flow is:

``` text
Robot Framework Test
        |
        v
     CanSim.py
        |
        v
   python-can
        |
        v
   Virtual CAN Bus
        |
   +----+----+
   |         |
  TX        RX
 send      receive
```

------------------------------------------------------------------------

# 2. Project Files

A typical project can look like:

``` text
project/
│
├── CanSim.py
├── can_tests.robot
└── README.md
```

### `CanSim.py`

Python library responsible for:

-   Creating the virtual CAN bus
-   Sending CAN frames
-   Receiving CAN frames
-   Checking CAN IDs
-   Checking CAN data
-   Closing the CAN bus

### `can_tests.robot`

Robot Framework test file containing test cases.

### `README.md`

This documentation.

------------------------------------------------------------------------

# 3. CAN Basics

## 3.1 What is CAN?

CAN = **Controller Area Network**.

It is a communication protocol commonly used in:

-   Automotive systems
-   Embedded systems
-   Industrial controllers
-   ECUs
-   Sensors
-   Motor controllers

Multiple devices can communicate over the same CAN bus.

Example:

``` text
ECU 1 --------+
              |
ECU 2 --------+-------- CAN BUS
              |
ECU 3 --------+
```

------------------------------------------------------------------------

# 4. CAN Frame

A simplified CAN message can be represented as:

``` text
+----------------+----------------------+
| CAN ID         | DATA                 |
+----------------+----------------------+
| 0x123          | 11 22 33             |
+----------------+----------------------+
```

For this project:

``` text
CAN ID = 0x123
DATA   = 0x11 0x22 0x33
```

means:

> Send a CAN message with identifier `0x123` and three data bytes:
> `0x11`, `0x22`, `0x33`.

------------------------------------------------------------------------

# 5. Standard and Extended CAN ID

CAN supports:

-   Standard ID: **11-bit**
-   Extended ID: **29-bit**

In this project:

``` python
is_extended_id=False
```

means the message uses a standard 11-bit CAN identifier.

------------------------------------------------------------------------

# 6. Python Basics Required for This Project

You do NOT need to learn all of Python.

The important Python features used here are:

  Feature              Example                       Meaning
  -------------------- ----------------------------- ---------------------------
  `import`             `import can`                  Import a library
  `class`              `class CanSim:`               Create a class
  `def`                `def send_frame()`            Define a function
  `self`               `self.tx`                     Current object
  `__init__`           `def __init__()`              Constructor
  `None`               `self.tx = None`              No value
  Parameters           `can_id`                      Input to function
  Default argument     `timeout=1`                   Default value
  `*args`              `*data`                       Multiple arguments
  `if`                 `if msg is None`              Condition
  `for`                `for bus in ...`              Loop
  `return`             `return msg`                  Return result
  `raise`              `raise AssertionError(...)`   Generate an error
  List                 `[1, 2, 3]`                   Collection
  Tuple                `(self.tx, self.rx)`          Collection
  List comprehension   `[... for b in data]`         Compact loop
  f-string             `f"ID={id}"`                  Formatted string
  Method               `bus.shutdown()`              Call an object's function
  Property             `msg.data`                    Access object data

------------------------------------------------------------------------

# 7. Python `class`

The project starts with:

``` python
class CanSim:
```

A class is a blueprint for an object.

Think about it like a C++ class:

``` cpp
class CanSim
{
    // members
    // functions
};
```

The Python class contains:

``` text
CanSim
 |
 +-- tx
 +-- rx
 |
 +-- connect_virtual_bus()
 +-- send_frame()
 +-- receive_frame()
 +-- frame_id_should_be()
 +-- frame_data_should_be()
 +-- disconnect()
```

------------------------------------------------------------------------

# 8. Python `self`

Python uses:

``` python
self
```

to refer to the current object.

For example:

``` python
self.tx
```

means:

> The `tx` member belonging to this particular `CanSim` object.

Since you know C++, think approximately:

``` cpp
this->tx
```

So:

``` python
self.tx
```

is conceptually similar to:

``` cpp
this->tx
```

------------------------------------------------------------------------

# 9. Python `__init__`

``` python
def __init__(self):
```

`__init__` is the constructor.

It runs automatically when an object is created.

Example:

``` python
class Student:

    def __init__(self):
        print("Student created")
```

When:

``` python
student = Student()
```

Python automatically executes:

``` python
__init__()
```

In this project:

``` python
def __init__(self):
    self.tx = None
    self.rx = None
```

initializes the transmit and receive buses.

Initially:

``` text
tx = None
rx = None
```

No bus is connected yet.

------------------------------------------------------------------------

# 10. Python `None`

``` python
self.tx = None
```

`None` means:

> There is currently no value/object.

For embedded C/C++ programmers, it is useful to think of it as
conceptually similar to a null state.

------------------------------------------------------------------------

# 11. Python Functions

Functions are declared using:

``` python
def
```

Example:

``` python
def receive_frame(self, timeout=1):
```

This defines a function called:

``` text
receive_frame
```

It has:

-   `self` → current object
-   `timeout` → input parameter
-   `1` → default timeout

If no timeout is supplied:

``` python
receive_frame()
```

Python uses:

``` text
timeout = 1
```

If we call:

``` python
receive_frame(0.5)
```

then:

``` text
timeout = 0.5
```

------------------------------------------------------------------------

# 12. `*args` / Multiple Arguments

The project uses:

``` python
def send_frame(self, can_id, *data):
```

The `*data` means:

> Accept any number of additional positional arguments.

Example:

``` python
send_frame(0x123, 0x11, 0x22, 0x33)
```

Conceptually:

``` text
can_id = 0x123

data =
(
    0x11,
    0x22,
    0x33
)
```

This is useful for CAN because a frame can contain multiple data bytes.

------------------------------------------------------------------------

# 13. Importing `python-can`

The first line is:

``` python
import can
```

This imports the `python-can` library.

After importing it, the code can use:

``` python
can.Bus(...)
can.Message(...)
```

The project does NOT implement the complete CAN protocol manually.

The `python-can` library handles the CAN interface functionality.

------------------------------------------------------------------------

# 14. Connecting to a Virtual CAN Bus

The function:

``` python
def connect_virtual_bus(self, channel="test_bus"):
```

creates two bus objects:

``` python
self.tx = can.Bus(
    interface="virtual",
    channel=channel
)

self.rx = can.Bus(
    interface="virtual",
    channel=channel
)
```

## Why `interface="virtual"`?

It means:

> Use a software virtual CAN interface instead of physical CAN hardware.

This is useful for automated tests.

You can test:

``` text
Send
Receive
ID validation
Data validation
Timeout behavior
```

without a physical CAN controller.

------------------------------------------------------------------------

# 15. Why TX and RX?

The project creates:

``` text
self.tx
self.rx
```

Conceptually:

``` text
             Virtual CAN Bus
                   |
          +--------+--------+
          |                 |
         TX                RX
       send()             recv()
```

`tx` is used for sending.

`rx` is used for receiving.

Both use the same virtual channel.

------------------------------------------------------------------------

# 16. Creating a CAN Message

The project uses:

``` python
msg = can.Message(
    arbitration_id=int(str(can_id), 0),
    data=[int(str(b), 0) for b in data],
    is_extended_id=False,
)
```

This creates a CAN message.

The important fields are:

``` text
arbitration_id
data
is_extended_id
```

------------------------------------------------------------------------

# 17. `arbitration_id`

``` python
arbitration_id=int(str(can_id), 0)
```

The CAN identifier is converted to an integer.

Why?

Robot Framework may provide:

``` text
"0x123"
```

as a string.

But `python-can` needs a numeric ID.

The expression:

``` python
int(str(can_id), 0)
```

does the conversion.

For example:

``` python
int("0x123", 0)
```

produces:

``` text
291
```

because:

``` text
0x123 = 291 decimal
```

The `0` tells Python to detect the number base from the prefix.

Examples:

``` python
int("123", 0)
int("0x123", 0)
```

------------------------------------------------------------------------

# 18. Converting CAN Data

This code:

``` python
data=[int(str(b), 0) for b in data]
```

is a Python **list comprehension**.

It is equivalent to:

``` python
converted_data = []

for b in data:
    value = int(str(b), 0)
    converted_data.append(value)

data = converted_data
```

For example:

``` text
Input:

"0x11"
"0x22"
"0x33"

        ↓

Conversion

        ↓

17
34
51

        ↓

[17, 34, 51]
```

------------------------------------------------------------------------

# 19. Sending a CAN Frame

The project uses:

``` python
self.tx.send(msg)
```

Meaning:

> Send the CAN message through the transmit bus.

The complete flow is:

``` text
Robot Framework
      |
      v
Send Frame 0x123 0x11 0x22 0x33
      |
      v
send_frame()
      |
      v
Create CAN Message
      |
      v
self.tx.send(msg)
      |
      v
Virtual CAN Bus
```

------------------------------------------------------------------------

# 20. Receiving a CAN Frame

The project uses:

``` python
msg = self.rx.recv(float(timeout))
```

`recv()` waits for a CAN frame.

For:

``` python
timeout = 0.5
```

the code waits up to 0.5 seconds.

If a message arrives:

``` text
msg = CAN message
```

If nothing arrives:

``` text
msg = None
```

------------------------------------------------------------------------

# 21. `if msg is None`

The code:

``` python
if msg is None:
```

means:

> Did we receive nothing?

If yes:

``` python
raise AssertionError("No CAN frame received")
```

The test fails unless the Robot Framework test specifically expects this
error.

------------------------------------------------------------------------

# 22. `raise AssertionError`

``` python
raise AssertionError("No CAN frame received")
```

means:

> Generate an error because the expected CAN frame was not received.

The error message is:

``` text
No CAN frame received
```

This is important for Robot Framework testing.

------------------------------------------------------------------------

# 23. `return msg`

``` python
return msg
```

means:

> Give the received CAN message back to the caller.

Robot Framework can then store it:

``` robot
${msg}=    Receive Frame    timeout=1
```

------------------------------------------------------------------------

# 24. Checking the CAN ID

The function:

``` python
def frame_id_should_be(self, msg, expected):
```

checks the received ID.

The comparison is:

``` python
if msg.arbitration_id != int(str(expected), 0):
```

`!=` means:

> Not equal.

If the IDs are different:

``` python
raise AssertionError(...)
```

The test fails.

------------------------------------------------------------------------

# 25. f-Strings

The project uses:

``` python
f"Expected ID {expected}, got {hex(msg.arbitration_id)}"
```

An f-string allows variables inside a string.

Example:

``` python
name = "Ahmed"

print(f"Hello {name}")
```

Output:

``` text
Hello Ahmed
```

In the CAN project, an error might look like:

``` text
Expected ID 0x123, got 0x456
```

------------------------------------------------------------------------

# 26. `hex()`

``` python
hex(291)
```

produces:

``` text
0x123
```

It converts an integer into hexadecimal representation.

Hexadecimal is especially useful when debugging embedded systems and
CAN.

------------------------------------------------------------------------

# 27. Checking CAN Data

The function:

``` python
def frame_data_should_be(self, msg, *expected):
```

accepts multiple expected data bytes.

Example:

``` robot
Frame Data Should Be    ${msg}    0x11    0x22    0x33
```

The Python code converts them:

``` python
want = [int(str(b), 0) for b in expected]
```

Then compares:

``` python
if list(msg.data) != want:
```

Meaning:

> Is the received data different from the expected data?

If yes, the test fails.

------------------------------------------------------------------------

# 28. Disconnecting the Bus

The project contains:

``` python
def disconnect(self):
    for bus in (self.tx, self.rx):
        if bus:
            bus.shutdown()
```

The tuple:

``` python
(self.tx, self.rx)
```

contains both buses.

The loop:

``` python
for bus in (self.tx, self.rx):
```

processes them one by one.

Equivalent idea:

``` text
bus = tx
shutdown tx

bus = rx
shutdown rx
```

The:

``` python
if bus:
```

checks that the bus exists before shutting it down.

------------------------------------------------------------------------

# 29. Complete Python Library

The main Python file is:

``` python
import can


class CanSim:
    ROBOT_LIBRARY_SCOPE = "TEST"

    def __init__(self):
        self.tx = None
        self.rx = None

    def connect_virtual_bus(self, channel="test_bus"):
        self.tx = can.Bus(
            interface="virtual",
            channel=channel
        )

        self.rx = can.Bus(
            interface="virtual",
            channel=channel
        )

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
                f"Expected ID {expected}, "
                f"got {hex(msg.arbitration_id)}"
            )

    def frame_data_should_be(self, msg, *expected):
        want = [int(str(b), 0) for b in expected]

        if list(msg.data) != want:
            raise AssertionError(
                f"Expected {want}, got {list(msg.data)}"
            )

    def disconnect(self):
        for bus in (self.tx, self.rx):
            if bus:
                bus.shutdown()
```

------------------------------------------------------------------------

# 30. Robot Framework Settings

The Robot Framework test starts with:

``` robot
*** Settings ***
Library         CanSim.py
Test Setup      Connect Virtual Bus
Test Teardown   Disconnect
```

## `Library`

``` robot
Library    CanSim.py
```

loads the Python library.

Python methods become Robot Framework keywords.

For example:

``` python
send_frame()
```

can be called as:

``` robot
Send Frame
```

Robot Framework automatically handles the keyword naming style.

------------------------------------------------------------------------

# 31. Test Setup

``` robot
Test Setup    Connect Virtual Bus
```

means:

> Before every test, connect to the virtual CAN bus.

Flow:

``` text
Start test
   |
   v
Connect Virtual Bus
   |
   v
Execute test
```

------------------------------------------------------------------------

# 32. Test Teardown

``` robot
Test Teardown    Disconnect
```

means:

> After every test, close the CAN buses.

Flow:

``` text
Execute test
   |
   v
Disconnect
   |
   v
End test
```

------------------------------------------------------------------------

# 33. Successful CAN Test

``` robot
*** Test Cases ***
Frame Is Received Correctly
    [Tags]    smoke

    Send Frame    0x123    0x11    0x22    0x33

    ${msg}=    Receive Frame    timeout=1

    Frame Id Should Be    ${msg}    0x123

    Frame Data Should Be    ${msg}    0x11    0x22    0x33
```

The flow is:

``` text
1. Connect virtual bus
        |
2. Send CAN frame
        |
        | ID = 0x123
        | DATA = 11 22 33
        |
3. Receive frame
        |
4. Check ID
        |
5. Check DATA
        |
6. Disconnect
```

Expected result:

``` text
PASS
```

------------------------------------------------------------------------

# 34. The Important Error Test

This test is:

``` robot
Receive Fails When Nothing Is Sent
    Run Keyword And Expect Error    No CAN frame received
    ...    Receive Frame    timeout=0.5
```

This test is NOT trying to successfully receive a CAN frame.

It is testing:

> What happens when there is no CAN frame?

------------------------------------------------------------------------

# 35. Understanding `Run Keyword And Expect Error`

This is a Robot Framework keyword.

It means:

> Run another keyword and expect it to generate an error.

Normally:

``` text
No error → PASS
Error → FAIL
```

But with:

``` robot
Run Keyword And Expect Error
```

the logic becomes:

``` text
Expected error → PASS
No error → FAIL
Wrong error → FAIL
```

------------------------------------------------------------------------

# 36. Understanding the Two Lines Together

These:

``` robot
Run Keyword And Expect Error    No CAN frame received
...    Receive Frame    timeout=0.5
```

are logically one command.

Read them in English:

> Run `Receive Frame` with a timeout of 0.5 seconds, and I expect it to
> generate the error `No CAN frame received`.

The:

``` robot
...
```

means:

> Continue the previous Robot Framework command on the next line.

------------------------------------------------------------------------

# 37. Error Test Execution

There is no:

``` robot
Send Frame
```

before receiving.

Therefore:

``` text
Receive Frame
      |
      v
Wait 0.5 seconds
      |
      v
No frame
      |
      v
msg = None
      |
      v
raise AssertionError
      |
      v
"No CAN frame received"
```

Robot Framework expected this error.

Therefore:

``` text
PASS
```

------------------------------------------------------------------------

# 38. Very Important Mental Model

Remember:

``` text
TEST 1
--------------------------------
Send frame
Receive frame
Check frame
Expected result: SUCCESS


TEST 2
--------------------------------
Do NOT send frame
Try to receive
Expected result: ERROR
```

Test 2 passes because the error is intentional and expected.

------------------------------------------------------------------------

# 39. What Does `...` Mean?

Robot Framework supports continuation lines.

Example:

``` robot
Some Keyword    argument1
...             argument2
...             argument3
```

This is equivalent to one logical keyword call.

In this project:

``` robot
Run Keyword And Expect Error    No CAN frame received
...    Receive Frame    timeout=0.5
```

means:

``` text
Run Keyword And Expect Error
    Expected error = No CAN frame received
    Keyword = Receive Frame
    timeout = 0.5
```

------------------------------------------------------------------------

# 40. Robot Framework Variables

This:

``` robot
${msg}
```

is a Robot Framework variable.

Example:

``` robot
${msg}=    Receive Frame    timeout=1
```

means:

> Store the return value of `Receive Frame` in `${msg}`.

Then:

``` robot
Frame Id Should Be    ${msg}    0x123
```

uses the received message.

------------------------------------------------------------------------

# 41. Complete Test Flow

The complete project works like this:

``` text
                    ROBOT FRAMEWORK
                          |
             +------------+------------+
             |                         |
       Successful Test           Error Test
             |                         |
             v                         v
       Send Frame                 No Send
             |                         |
             v                         v
       Receive Frame              Receive Frame
             |                         |
             v                         v
       Check ID/Data               No Frame
             |                         |
             v                         v
           PASS                 Expected Error
                                       |
                                       v
                                     PASS
```

------------------------------------------------------------------------

# 42. Python-to-Robot Mapping

  Python                     Robot Framework
  -------------------------- ------------------------
  `connect_virtual_bus()`    `Connect Virtual Bus`
  `send_frame()`             `Send Frame`
  `receive_frame()`          `Receive Frame`
  `frame_id_should_be()`     `Frame Id Should Be`
  `frame_data_should_be()`   `Frame Data Should Be`
  `disconnect()`             `Disconnect`

Robot Framework is essentially using the Python class as a custom
library.

------------------------------------------------------------------------

# 43. Python Features to Review Before Going Further

Study these in this exact order:

## Level 1 --- Basic Python

``` text
Variables
Strings
Integers
Lists
Tuples
if
for
```

## Level 2 --- Functions

``` text
def
parameters
return
default parameters
*args
```

## Level 3 --- Classes

``` text
class
objects
self
__init__
methods
attributes
```

## Level 4 --- Error Handling

``` text
raise
Exception
AssertionError
try/except
```

## Level 5 --- Useful Python Syntax

``` text
f-strings
list comprehensions
object.property
method()
```

------------------------------------------------------------------------

# 44. CAN Topics to Review

Before modifying the project, make sure you understand:

``` text
CAN bus
CAN node
CAN controller
CAN transceiver
CAN frame
CAN ID
Standard ID
Extended ID
Data field
Arbitration
Dominant bit
Recessive bit
ACK
CRC
Bit stuffing
CAN errors
CAN FD
```

For this particular project, especially understand:

``` text
CAN ID
CAN data
standard vs extended ID
send
receive
timeout
```

------------------------------------------------------------------------

# 45. `python-can` API Used in This Project

The project currently uses:

## Bus

``` python
can.Bus(...)
```

Creates the CAN bus interface.

## Message

``` python
can.Message(...)
```

Creates a CAN message.

## Send

``` python
bus.send(message)
```

Transmits a message.

## Receive

``` python
bus.recv(timeout)
```

Waits for a message.

## Shutdown

``` python
bus.shutdown()
```

Closes the bus interface.

------------------------------------------------------------------------

# 46. Debugging Checklist

If sending does not work, check:

``` text
[ ] python-can installed
[ ] Robot Framework installed
[ ] CanSim.py found
[ ] Correct interface = "virtual"
[ ] Same channel used by TX and RX
[ ] CAN ID is valid
[ ] Data bytes are valid
[ ] Standard/extended ID is correct
```

If receiving times out:

``` text
[ ] Was a frame actually sent?
[ ] Are TX and RX on the same virtual channel?
[ ] Is timeout long enough?
[ ] Is another test consuming the message?
```

------------------------------------------------------------------------

# 47. Important Difference: Timeout vs Error

A timeout is not automatically a Python error.

This:

``` python
msg = self.rx.recv(0.5)
```

can simply return:

``` python
None
```

The project deliberately converts that situation into an error:

``` python
if msg is None:
    raise AssertionError("No CAN frame received")
```

This makes the behavior useful for automated testing.

------------------------------------------------------------------------

# 48. Why Use a Virtual CAN Bus?

Advantages:

-   No physical CAN hardware required
-   Fast automated testing
-   Repeatable tests
-   Easy CI/CD integration
-   Easy negative testing
-   Easy timeout testing
-   Useful for development before hardware is available

Example:

``` text
Physical system:

PC → CAN adapter → CAN transceiver → ECU


This project:

PC → python-can → Virtual CAN
```

------------------------------------------------------------------------

# 49. Recommended Learning Path for This Project

Follow this order.

### Step 1

Understand:

``` python
class
self
__init__
```

### Step 2

Understand:

``` python
def
parameters
return
```

### Step 3

Understand:

``` python
*data
```

### Step 4

Understand:

``` python
for
if
list
tuple
```

### Step 5

Understand:

``` python
[int(str(b), 0) for b in data]
```

### Step 6

Understand:

``` python
raise AssertionError
```

### Step 7

Refresh CAN fundamentals.

### Step 8

Learn the small `python-can` API used here.

### Step 9

Learn Robot Framework syntax.

### Step 10

Start modifying the project.

------------------------------------------------------------------------

# 50. Quick Cheat Sheet

## Python

``` python
class A:
```

Create a class.

``` python
def f():
```

Create a function.

``` python
self.x
```

Current object's member.

``` python
None
```

No value.

``` python
*args
```

Accept multiple arguments.

``` python
for x in items:
```

Loop through items.

``` python
if condition:
```

Conditional execution.

``` python
return x
```

Return a value.

``` python
raise AssertionError("error")
```

Generate a test failure/error.

``` python
f"Hello {name}"
```

Formatted string.

``` python
[x for x in items]
```

List comprehension.

------------------------------------------------------------------------

## CAN

``` text
ID
```

Identifies/arbitrates a CAN message.

``` text
DATA
```

Payload bytes.

``` text
Standard ID
```

11-bit CAN identifier.

``` text
Extended ID
```

29-bit CAN identifier.

``` text
TX
```

Transmit.

``` text
RX
```

Receive.

``` text
timeout
```

Maximum time to wait for a message.

------------------------------------------------------------------------

## Robot Framework

``` robot
*** Settings ***
```

Test/library configuration.

``` robot
Library
```

Load a library.

``` robot
Test Setup
```

Run before each test.

``` robot
Test Teardown
```

Run after each test.

``` robot
*** Test Cases ***
```

Define tests.

``` robot
${variable}
```

Robot variable.

``` robot
...
```

Continue a command on the next line.

``` robot
Run Keyword And Expect Error
```

Run something and expect it to fail.

------------------------------------------------------------------------

# 51. Most Important Concept to Remember

When you see:

``` robot
Run Keyword And Expect Error    No CAN frame received
...    Receive Frame    timeout=0.5
```

translate it in your head to:

``` text
"I expect Receive Frame to fail
because no CAN frame should be available."
```

Then connect it to the Python:

``` python
msg = self.rx.recv(0.5)

if msg is None:
    raise AssertionError("No CAN frame received")
```

So the two files are directly connected:

``` text
Robot Framework
      |
      | Receive Frame
      v
Python
      |
      | rx.recv(0.5)
      v
Virtual CAN
      |
      | nothing received
      v
msg = None
      |
      v
AssertionError
      |
      v
Robot Framework
      |
      | Expected error?
      v
     YES
      |
      v
    PASS
```

------------------------------------------------------------------------

# 52. Final Mental Model

The whole project can be remembered as:

``` text
                 ROBOT TEST
                     |
                     v
               CanSim.py
                     |
          +----------+----------+
          |                     |
       SEND                   RECEIVE
          |                     |
          v                     v
     self.tx.send()       self.rx.recv()
          |                     |
          +----------+----------+
                     |
                     v
               Virtual CAN
                     |
                     v
              CAN Message
              ID + DATA
```

The project is essentially a **test adapter**:

``` text
Robot Framework
      ↓
CanSim Python Library
      ↓
python-can
      ↓
Virtual CAN
```

Once these four layers are clear, the rest of the project becomes much
easier to follow.
