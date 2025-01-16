`define PC_FETCH 4 
module icache (
        input  logic clk_i,
        input  logic [`MXLEN -1 : 0] pc_i,
        input  logic  icc_refill_ack_i,
        input  logic [`CACHE_INDEX_WD  - 1 : 0] icc_refill_addr_i,
        output logic [`PC_FETCH*`MXLEN -1 : 0] instr_o,
        output logic instr_vld_o,
        output logic icc_miss_o,
        output logic icc_refill_rq_o
        );
endmodule