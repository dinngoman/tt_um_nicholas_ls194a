
![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# SN74LS194A-Compatible 4-Bit Universal Shift Register

### TinyTapeout -- TTSKY26a (SKY130)

This project was created as part of the TT Workshop at FOSSi Down Underflow 2026.\
Thank you to the sponsorship by IQonIC Works Pty Ltd <https://iqonicworks.com>

------------------------------------------------------------------------

## Overview

This project implements a **4-bit bidirectional universal shift
register** functionally compatible with the classical **SN74LS194A**
device.

Supported operations:

-   Hold (no change)\
-   Shift Right\
-   Shift Left\
-   Parallel Load\
-   Asynchronous active-low clear

The design is written in synthesizable Verilog and targets the
**TinyTapeout SKY130 (TTSKY26a)** shuttle.

This implementation reproduces logical behavior only and does not
emulate LS-TTL electrical characteristics.

------------------------------------------------------------------------

## Functional Description

The register updates on the **rising edge of `clk`**.

An asynchronous active-low reset (`rst_n`) clears all outputs to zero.

### Mode Select (S1, S0)

  S1   S0   Operation
  ---- ---- ---------------
  0    0    Hold
  0    1    Shift Right
  1    0    Shift Left
  1    1    Parallel Load

------------------------------------------------------------------------

## Register Behavior

### Asynchronous Clear

When:

    rst_n = 0

All outputs are cleared:

    QA = QB = QC = QD = 0

------------------------------------------------------------------------

### Shift Right (S1 S0 = 0 1)

    QA ← SR
    QB ← QA(previous)
    QC ← QB(previous)
    QD ← QC(previous)

Serial data enters at **QA**.

------------------------------------------------------------------------

### Shift Left (S1 S0 = 1 0)

    QD ← SL
    QC ← QD(previous)
    QB ← QC(previous)
    QA ← QB(previous)

Serial data enters at **QD**.

------------------------------------------------------------------------

### Parallel Load (S1 S0 = 1 1)

    QA ← A
    QB ← B
    QC ← C
    QD ← D

------------------------------------------------------------------------

## TinyTapeout Pin Mapping

### Inputs (`ui_in[7:0]`)

  Pin   Signal   Description
  ----- -------- ----------------------------
  ui0   S0       Mode select
  ui1   S1       Mode select
  ui2   SR       Serial input (shift right)
  ui3   SL       Serial input (shift left)
  ui4   A        Parallel input
  ui5   B        Parallel input
  ui6   C        Parallel input
  ui7   D        Parallel input

------------------------------------------------------------------------

### Outputs (`uo_out[7:0]`)

  Pin        Signal   Description
  ---------- -------- ---------------------
  uo0        QA       Register bit 0
  uo1        QB       Register bit 1
  uo2        QC       Register bit 2
  uo3        QD       Register bit 3
  uo4--uo7   ---      Unused (driven low)

------------------------------------------------------------------------

### Global Signals

  Signal   Description
  -------- ---------------------------------------------------
  clk      Positive-edge clock
  rst_n    Asynchronous active-low reset
  ena      TinyTapeout enable (always high during operation)

------------------------------------------------------------------------

## Implementation Notes

-   Fully synthesizable Verilog\
-   Positive-edge triggered\
-   Asynchronous reset\
-   No bidirectional IO used\
-   All unused outputs driven low\
-   Designed for SKY130 digital flow

------------------------------------------------------------------------

## Verification

The design has successfully completed:

-   RTL simulation (cocotb)\
-   Gate-level simulation\
-   GDS generation\
-   TinyTapeout precheck validation\
-   GitHub Actions CI

Target shuttle: **TTSKY26a**

------------------------------------------------------------------------

## Applications

-   Educational digital logic demonstration\
-   Serial-to-parallel conversion\
-   Parallel-to-serial conversion\
-   Shift-based state machines\
-   Basic digital building block

------------------------------------------------------------------------

## Compliance Statement

This design reproduces the logical behavior of the SN74LS194A universal
shift register.\
It is not electrically or timing compatible with LS-TTL hardware.

------------------------------------------------------------------------

## Author

nicholas@dinngoman\
TinyTapeout TTSKY26a Submission
