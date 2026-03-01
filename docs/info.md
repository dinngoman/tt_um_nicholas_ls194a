# Universal Shift Register (SN74LS194A compatible)

This TinyTapeout design implements the logic behaviour of the TI SN74LS194A / SN74194:
- 4-bit register with shift-left, shift-right, parallel load, and hold
- Async active-low clear (mapped to TinyTapeout `rst_n`)

## Controls (ui_in)
- ui[1:0] = {S1,S0} mode select  
  - 00 hold  
  - 01 shift right (SR enters QA)  
  - 10 shift left  (SL enters QD)  
  - 11 parallel load (A..D to QA..QD)
- ui[2] = SR serial in (for shift right)
- ui[3] = SL serial in (for shift left)
- ui[7:4] = A,B,C,D parallel inputs

## Outputs (uo_out)
- uo[0] = QA
- uo[1] = QB
- uo[2] = QC
- uo[3] = QD
