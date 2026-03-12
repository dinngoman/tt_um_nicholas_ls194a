SN74LS194A-Compatible
4-Bit Bidirectional Universal Shift Register

TinyTapeout – TTSKY26a (SKY130)

1. General Description

This design implements a 4-bit bidirectional universal shift register functionally compatible with the behavior of the classic SN74LS194A device.

The register supports:

Parallel load

Shift left

Shift right

Hold (no change)

Asynchronous active-low clear

The implementation is fully digital and synthesized using the TinyTapeout SKY130 flow for shuttle TTSKY26a.

This project models functional behavior only and does not replicate LS-TTL electrical characteristics.

2. Features

4-bit storage register (QA–QD)

Bidirectional serial shifting

Parallel data loading

Mode control via 2-bit selector

Asynchronous active-low reset

Positive-edge clocked

Synthesizable Verilog

Clean TinyTapeout precheck and GDS generation

3. Functional Block Diagram
        +-----------------------------+
        |        Mode Control         |
        |         (S1, S0)            |
        +---------------+-------------+
                        |
                        v
        +-------------------------------------+
        | 4-bit Register (QA QB QC QD)       |
        |                                     |
SR ---> | Shift Right Logic                   |
SL ---> | Shift Left Logic                    |
A–D --> | Parallel Load Logic                 |
        +-------------------------------------+
                        |
                        v
                    QA QB QC QD
4. Operating Modes

The register updates on the rising edge of clk.

S1	S0	Operation
0	0	Hold
0	1	Shift Right
1	0	Shift Left
1	1	Parallel Load
5. Functional Truth Table
5.1 Asynchronous Clear

When rst_n = 0:

QA = QB = QC = QD = 0

This operation overrides clock and mode inputs.

5.2 Shift Right (S1 S0 = 0 1)
QA ← SR
QB ← QA(previous)
QC ← QB(previous)
QD ← QC(previous)

Serial input enters at QA.

5.3 Shift Left (S1 S0 = 1 0)
QD ← SL
QC ← QD(previous)
QB ← QC(previous)
QA ← QB(previous)

Serial input enters at QD.

5.4 Parallel Load (S1 S0 = 1 1)
QA ← A
QB ← B
QC ← C
QD ← D
6. TinyTapeout Pin Configuration
6.1 Dedicated Inputs (ui_in[7:0])
Pin	Signal	Description
ui0	S0	Mode select
ui1	S1	Mode select
ui2	SR	Serial input (shift right)
ui3	SL	Serial input (shift left)
ui4	A	Parallel input
ui5	B	Parallel input
ui6	C	Parallel input
ui7	D	Parallel input
6.2 Dedicated Outputs (uo_out[7:0])
Pin	Signal	Description
uo0	QA	Register bit 0
uo1	QB	Register bit 1
uo2	QC	Register bit 2
uo3	QD	Register bit 3
uo4–uo7	—	Unused (driven low)
6.3 Global Signals
Signal	Description
clk	Positive-edge clock
rst_n	Asynchronous active-low clear
ena	Always enabled (TinyTapeout infrastructure)
7. Electrical & Timing (Digital Model)

Process: SKY130 CMOS

Supply: Managed by TinyTapeout infrastructure

Clock: External (default simulation 1 MHz)

Reset: Asynchronous active-low

Logic type: Fully synchronous digital (except async reset)

Note: This is a behavioral CMOS implementation and does not model LS-TTL propagation delays or electrical drive characteristics.

8. Verification Status

The design has successfully completed:

RTL simulation (cocotb)

Gate-level simulation

GDS generation

TinyTapeout precheck validation

GitHub Actions CI

Target shuttle: TTSKY26a

9. Applications

Educational digital logic demonstration

Building block for FSMs

Serial-to-parallel conversion

Parallel-to-serial conversion

Experimental digital pipelines

10. Compliance Statement

This implementation reproduces the logical behavior of the SN74LS194A universal shift register but is not electrically or timing-compatible with LS-TTL hardware.

11. Author

Nicholas
TinyTapeout TTSKY26a Submission
