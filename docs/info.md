# Universal Shift Register (SN74LS194A compatible)

This project implements a 4-bit bidirectional “universal” shift register compatible with the SN74LS194A / 74194 behavior:
- Hold (no change)
- Shift right (serial input SR enters QA)
- Shift left (serial input SL enters QD)
- Parallel load (A..D into QA..QD)
- Asynchronous active-low clear (TinyTapeout `rst_n`)

## Pinout

Inputs (`ui_in`)
- `ui[0]` = S0
- `ui[1]` = S1
- `ui[2]` = SR (serial-in for shift-right; enters QA)
- `ui[3]` = SL (serial-in for shift-left; enters QD)
- `ui[4]` = A (parallel in)
- `ui[5]` = B (parallel in)
- `ui[6]` = C (parallel in)
- `ui[7]` = D (parallel in)

Outputs (`uo_out`)
- `uo[0]` = QA
- `uo[1]` = QB
- `uo[2]` = QC
- `uo[3]` = QD
- `uo[7:4]` unused

Reset
- `rst_n` = async clear (active-low)

## How it works

On each rising edge of `clk`, the register updates according to `{S1,S0}`:
- `00`: hold (no change)
- `01`: shift right: `QA<-SR`, `QB<-QA`, `QC<-QB`, `QD<-QC`
- `10`: shift left:  `QD<-SL`, `QC<-QD`, `QB<-QC`, `QA<-QB`
- `11`: parallel load: `QA..QD <- A..D`

When `rst_n` is low, the register clears immediately to `0000` (asynchronous clear).

## How to test

1) **Clear**
- Pull `rst_n` low briefly then high.
- Expect `QA..QD = 0000`.

2) **Parallel load**
- Set `S1=1, S0=1`.
- Set `A..D = 1010` (or any pattern).
- Pulse `clk` once.
- Expect `QA..QD = 1010`.

3) **Shift right**
- Set `S1=0, S0=1`.
- Set `SR=1` (leave `SL` don’t care).
- Pulse `clk` once.

4) **Shift left**
- Set `S1=1, S0=0`.
- Set `SL=1` (leave `SR` don’t care).
- Pulse `clk` once.
