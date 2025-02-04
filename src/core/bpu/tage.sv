import bpu_pkg::*;
module tage_predcitor
    (
        input logic clk_i,
        input logic rst_i,
        input logic update_enable_i,
        input logic presuccess_i,
        input logic premiss_i,
        input logic [`HIST_LEN - 1 : 0] ghr_i,
        input logic [`MXLEN - 1 : 0] pc_i,
        output logic taken_o       
    );
endmodule