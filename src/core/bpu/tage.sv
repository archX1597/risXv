import bpu_pkg::*;
module tage_predcitor
    (
        input logic clk_i,
        input logic rstn_i,
        input logic update_enable_i,
        input logic presuccess_i,
        input logic premiss_i,
        input logic [`HIST_LEN - 1 : 0] ghr_i,
        input logic [`MXLEN - 1 : 0] pc_i,
        output logic taken_o       
    );
    // Define the number of tables
    `define NUM_TABLES 3
    // Define the number of entries in each table
    `define NUM_ENTRIES 256
    // Define the number of bits in the global history register
    `define GHIST_LEN 64
    `define TAGE1_LEN 16
    `define TAGE2_LEN 32
    `define TAGE3_LEN 64
    //
    logic [$clog2(`NUM_ENTRIES) - 1 : 0] Tgae_index_0,Tage_index_1,Tage_index_2,Tage_index_3;
    logic [9:0] Tage1_entry_Tag;
    logic [11:0] Tage2_entry_Tag;
    logic [13:0] Tage3_entry_Tag;
    // Define the tables    
    always_comb begin
        Tage_index_1 = pc_i[9:2] ^ ghr_i[7:0] ^ ghr_i[15:8];
        Tage_index_2 = pc_i[9:2] ^ ghr_i[7:0] ^ ghr_i[15:8] ^ ghr_i[23:16] ^ ghr_i[31:24];
        Tage_index_3 = pc_i[9:2] ^ ghr_i[7:0] ^ ghr_i[15:8] ^ ghr_i[23:16] ^ ghr_i[31:24] ^ ghr_i[39:32] ^ ghr_i[47:40] ^ ghr_i[55:48] ^ ghr_i[63:56];
    end

    //Tag hash
    always_comb begin
        //Gnerate Tage1_entry_Tag 、Tage 2_entry_Tag、Tage 3_entry_Tag
        Tage1_entry_Tag = (pc_i[11 : 2] ^ ghr_i[`TAGE1_LEN - 1 : 0]) ;
        Tage2_entry_Tag = (pc_i[13 : 2] ^ ghr_i[`TAGE2_LEN - 1 : 0]) ;
        Tage3_entry_Tag = (pc_i[15 : 2] ^ ghr_i[`TAGE3_LEN - 1 : 0]) ;
    end
    
    // Define the tables
endmodule