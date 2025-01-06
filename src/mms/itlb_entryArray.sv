import mms_pkg::*;
module itlb_entryArray(
  input logic clk_i,
  input logic rstn_i,
  input logic [`TLB_ENTRY_NUM - 1 : 0 ] wr_en_i,
  input logic [`TLB_ENTRY_NUM - 1 : 0]  rd_en_i,
  input logic [`MXLEN - 1 : 0] pte_wr_i,
  output logic [`MXLEN - 1 : 0] pte_rd_o
);

    pte_t pte_rd_array [`TLB_ENTRY_NUM - 1 : 0];
    genvar i;
    generate
    //instance Ram line
     for (i = 0; i < `ITLB_ENTRY_NUM; i++) begin : gen_itlb_entry
            itlb_entry u_itlb_entry(
                // Inputs
                .clk_i     (clk_i),
                .pte_wr_i  (pte_wr_i),
                .read_en_i (rd_en_i[i]),
                .rstn_i    (rstn_i),
                .write_en_i(wr_en_i[i]),
                // Outputs
                .pte_rd_o  (pte_rd_array[i])
            );
     end
    endgenerate


    always_comb begin
        pte_rd_o = '0;
        for (int i = 0 ; i < `ITLB_ENTRY_NUM; i++) begin
            pte_rd_o = pte_rd_o | pte_rd_array[i];
        end
    end
endmodule