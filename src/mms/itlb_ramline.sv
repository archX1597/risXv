import mms_pkg::*;
module itlb_ramline(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic read_en_i,
    input  logic write_en_i,
    input  logic [`MXLEN  - 1 : 0]  pte_wr_i,
    output logic [`MXLEN   - 1 : 0] pte_rd_o
); 
    pte_t pte_d, pte_q;
    `D_FLIP_FLOP(pte_reg, clk_i, rstn_i, pte_d, pte_q, write_en_i);
    assign pte_d = pte_wr_i;
    assign pte_rd_o = read_en_i ? pte_q : '0;
endmodule