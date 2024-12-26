import mms_pkg::*;

module itlb(
        //input port
        input  logic clk_i,
        input  logic rstn_i,
        input  logic flush_i,
        input  logic fu_access_i,
        input  logic [`VADDR_WD - 1 :0 ] vaddr_i,
        input  logic asid_flush_i,
        //output port
        output logic [`PADDR_WD - 1 : 0] paddr_o,
        output logic itlb_hit_o,
        //exception outport
        output logic page_fault_o,
        output logic access_except_o,
        output logic misalign_access_o
    );


//Page entry and Page
    


//state machine for TLB

    always_comb begin


    end


endmodule