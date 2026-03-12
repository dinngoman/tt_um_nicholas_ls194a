/*
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_nicholas_ls194a (
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);

  wire s0     = ui_in[0];
  wire s1     = ui_in[1];
  wire sr_ser = ui_in[2];
  wire sl_ser = ui_in[3];

  wire a_in   = ui_in[4];
  wire b_in   = ui_in[5];
  wire c_in   = ui_in[6];
  wire d_in   = ui_in[7];

  reg [3:0] q; // q[0]=QA ... q[3]=QD

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q <= 4'b0000;
    end else begin
      case ({s1, s0})
        2'b00: q <= q;                 // hold
        2'b01: begin                   // shift right (SR enters QA)
          q[0] <= sr_ser;
          q[1] <= q[0];
          q[2] <= q[1];
          q[3] <= q[2];
        end
        2'b10: begin                   // shift left (SL enters QD)
          q[3] <= sl_ser;
          q[2] <= q[3];
          q[1] <= q[2];
          q[0] <= q[1];
        end
        2'b11: begin                   // parallel load A..D -> QA..QD
          q[0] <= a_in;
          q[1] <= b_in;
          q[2] <= c_in;
          q[3] <= d_in;
        end
      endcase
    end
  end

  assign uo_out[0] = q[0];
  assign uo_out[1] = q[1];
  assign uo_out[2] = q[2];
  assign uo_out[3] = q[3];
  assign uo_out[7:4] = 4'b0000;

  assign uio_out = 8'b0000_0000;
  assign uio_oe  = 8'b0000_0000;

  wire _unused = &{uio_in, ena, 1'b0};

endmodule
