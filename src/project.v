/*
 * Copyright (c) 2026 Nicholas
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

// SN74LS194A-equivalent 4-bit universal shift register for TinyTapeout
// Modes via S1,S0 (sampled on rising clk edge):
//   00: Hold
//   01: Shift Right  (QA<-SR, QB<-QA, QC<-QB, QD<-QC)
//   10: Shift Left   (QD<-SL, QC<-QD, QB<-QC, QA<-QB)
//   11: Parallel Load (QA..QD <- A..D)
//
// Async clear is active-low via rst_n (TinyTapeout reset).

module tt_um_nicholas_ls194a (
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,    // Dedicated outputs
  input  wire [7:0] uio_in,    // IOs: Input path
  output wire [7:0] uio_out,   // IOs: Output path
  output wire [7:0] uio_oe,    // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // clock
  input  wire       rst_n      // reset_n - low to reset (used as async clear)
);

  // Inputs
  wire s0     = ui_in[0];
  wire s1     = ui_in[1];
  wire sr_ser = ui_in[2];
  wire sl_ser = ui_in[3];

  wire a_in   = ui_in[4];
  wire b_in   = ui_in[5];
  wire c_in   = ui_in[6];
  wire d_in   = ui_in[7];

  // Internal register: q[0]=QA, q[1]=QB, q[2]=QC, q[3]=QD
  reg [3:0] q;

  // Async clear (active-low), update on rising edge
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q <= 4'b0000;
    end else begin
      case ({s1, s0})
        2'b00: begin
          // hold
          q <= q;
        end

        2'b01: begin
          // shift right: SR enters QA; QA->QB->QC->QD
          q[0] <= sr_ser;
          q[1] <= q[0];
          q[2] <= q[1];
          q[3] <= q[2];
        end

        2'b10: begin
          // shift left: SL enters QD; QD->QC->QB->QA
          q[3] <= sl_ser;
          q[2] <= q[3];
          q[1] <= q[2];
          q[0] <= q[1];
        end

        2'b11: begin
          // parallel load: A..D -> QA..QD
          q[0] <= a_in;
          q[1] <= b_in;
          q[2] <= c_in;
          q[3] <= d_in;
        end

        default: begin
          q <= q;
        end
      endcase
    end
  end

  // Outputs (all outputs must be assigned)
  assign uo_out[0] = q[0];     // QA
  assign uo_out[1] = q[1];     // QB
  assign uo_out[2] = q[2];     // QC
  assign uo_out[3] = q[3];     // QD
  assign uo_out[7:4] = 4'b0000;

  // No bidirectional IO used
  assign uio_out = 8'b0000_0000;
  assign uio_oe  = 8'b0000_0000;

  // Prevent unused warnings
  wire _unused = &{ena, uio_in, 1'b0};

endmodule
