import mms_pkg::*;
module itlb_tagArray(
        input  logic clk_i,
        input  logic rstn_i,
        input  logic tlb_flush_i,
        input  logic [`ITLB_ENTRY_SIZE - 1 : 0] write_en_i,
        input  logic [`ASID_WD-1:0] asid_i,
        input  logic [`VPN0_WD + `VPN1_WD - 1 : 0] vpn_i,
        output logic [`ITLB_ENTRY_SIZE - 1:0] itlb_entry_hit_o
    );


    // Generate the CAM lines
    genvar i;
    generate
        for (i = 0; i < `ITLB_ENTRY_SIZE; i++) begin : gen_itlb_tag
            itlb_tag u_itlb_tag (
                // Inputs
                .asid_i     (asid_i),
                .clk_i      (clk_i),
                .pte_g      (pte_g),
                .rstn_i     (rstn_i),
                .tag_vpn_i  (vpn_i),
                .tlb_flush_i(tlb_flush_i),
                .write_en_i (write_en_i[i]),
                // Outputs
                .hit_o      (itlb_entry_hit_o[i])
            );
        end
    endgenerate
endmodule