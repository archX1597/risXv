import mms_pkg::*;
module itlb_entryArray(
        input logic clk_i,
        input logic rstn_i,
        input logic [`ITLB_ENTRY_SIZE - 1 : 0 ] wr_en_i,
        input logic [`ITLB_ENTRY_SIZE - 1 : 0]  rd_en_i,
        input logic [`MXLEN - 1 : 0] pte_wr_i,
        output logic [`MXLEN - 1 : 0] pte_rd_o
    );

    pte_t pte_rd_array [`ITLB_ENTRY_SIZE - 1 : 0];
    genvar i;
    generate
        //instance ITLB entry Array
        for (i = 0; i < `ITLB_ENTRY_SIZE; i++) begin : gen_itlb_entry
            itlb_entry u_itlb_entry(
                // Inputs
                .clk_i     (clk_i),
                .pte_wr_entry_i  (pte_wr_i),
                .read_en_i (rd_en_i[i]),
                .rstn_i    (rstn_i),
                .write_en_i(wr_en_i[i]),
                // Outputs
                .pte_rd_entry_o  (pte_rd_array[i])
            );
        end
    endgenerate

    assign pte_rd_o =   pte_rd_array[0]
                      | pte_rd_array[1] 
                      | pte_rd_array[2] 
                      | pte_rd_array[3] 
                      | pte_rd_array[4] 
                      | pte_rd_array[5] 
                      | pte_rd_array[6] 
                      | pte_rd_array[7] 
                      | pte_rd_array[8] 
                      | pte_rd_array[9] 
                      | pte_rd_array[10]
                      | pte_rd_array[11]
                      | pte_rd_array[12]
                      | pte_rd_array[13]
                      | pte_rd_array[14]
                      | pte_rd_array[15]
                      | pte_rd_array[16]
                      | pte_rd_array[17]
                      | pte_rd_array[18]
                      | pte_rd_array[19]
                      | pte_rd_array[20]
                      | pte_rd_array[21]
                      | pte_rd_array[22]
                      | pte_rd_array[23]
                      | pte_rd_array[24]
                      | pte_rd_array[25]
                      | pte_rd_array[26]
                      | pte_rd_array[27]
                      | pte_rd_array[28]
                      | pte_rd_array[29]
                      | pte_rd_array[30];
endmodule