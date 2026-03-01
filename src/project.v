/*
  tt_um_nicholas_ls194a
  SN74LS194A / SN74194-compatible 4-bit bidirectional universal shift register.

  Modes selected by S1,S0 (sampled on rising edge of clk):
    00: Hold (clock inhibit / no change)
    01: Shift right  (SR -> QA, QA -> QB -> QC -> QD)
    10: Shift left   (SL -> QD, QD -> QC -> QB -> QA)
    11: Parallel load (A..D -> QA..QD)

  Async clear (active-low) dominates, equivalent to CLR on the TI part.
*/

module tt_um_nicholas_ls194a (
    input  wire        clk,
    input  wire        rst_n,     // TinyTapeout active-low reset; used as async CLR
    input  wire [7:0]  ui_in,
    output wire [7:0]  uo_out,
    input  wire [7:0]  uio_in,
    output wire [7:0]  uio_out,
    output wire [7:0]  uio_oe
);

    // Inputs
    wire s0     = ui_in[0];
    wire s1     = ui_in[1];
    wire sr_ser = ui_in[2];   // shift-right serial input (into QA)
    wire sl_ser = ui_in[3];   // shift-left  serial input (into QD)

    wire a_in   = ui_in[4];
    wire b_in   = ui_in[5];
    wire c_in   = ui_in[6];
    wire d_in   = ui_in[7];

    // q[0]=QA, q[1]=QB, q[2]=QC, q[3]=QD
    reg [3:0] q;

    // Async active-low clear, posedge clock update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 4'b0000;
        end else begin
            case ({s1, s0})
                2'b00: begin
                    // Hold
                    q <= q;
                end
                2'b01: begin
                    // Shift right: SR -> QA; QA->QB->QC->QD
                    q[0] <= sr_ser;
                    q[1] <= q[0];
                    q[2] <= q[1];
                    q[3] <= q[2];
                end
                2'b10: begin
                    // Shift left: SL -> QD; QD->QC->QB->QA
                    q[3] <= sl_ser;
                    q[2] <= q[3];
                    q[1] <= q[2];
                    q[0] <= q[1];
                end
                2'b11: begin
                    // Parallel load: A..D -> QA..QD
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

    // Outputs
    assign uo_out[0] = q[0];   // QA
    assign uo_out[1] = q[1];   // QB
    assign uo_out[2] = q[2];   // QC
    assign uo_out[3] = q[3];   // QD
    assign uo_out[7:4] = 4'b0000;

    // Not using bidir IO
    assign uio_out = 8'b0000_0000;
    assign uio_oe  = 8'b0000_0000;

    // Keep lint happy
    wire _unused = &uio_in;

endmodule
