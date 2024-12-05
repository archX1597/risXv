import mms_pkg::*;

module itlb(
    input logic clk_i,
    input logic rstn_i,
    input logic flush_i,
    input logic fu_access_i,
    input logic [`INST_WD-1 :0 ] fu_vaddr_i,
    input logic asid_flush_i,
    output logic [`INST_WD - 1 : 0] fu_paddr_o,
    output logic fu_hit_o
);

    always_comb begin
        

    end


endmodule