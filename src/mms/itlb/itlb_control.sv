import mms_pkg::*;
import register_pkg::*;
module itlb_control (
        input logic [`MXLEN - 1 : 0] satp_i,
        input logic [`MXLEN - 1 : 0] pte_i,
        input logic clk_i,rstn_i,
        input logic rd_access_i,
        input logic wr_access_i,
        input logic  tag_hit_i,
        output logic tlb_miss_o,
        output logic tlb_hit_o
    );

    satp_t satp;
    pte_t  pte;
    logic tlb_miss;
    logic tlb_hit ;

    assign satp = satp_i;
    assign pte = pte_i  ;
    assign tlb_miss   = ~tag_hit_i | ~pte.read & pte.write | ~pte.xcute | (satp.mode == 2'b00) ;
    assign tlb_hit    = ~tlb_miss ;
    assign tlb_miss_o = tlb_miss;
    assign tlb_hit_o  = tlb_hit ;  

endmodule