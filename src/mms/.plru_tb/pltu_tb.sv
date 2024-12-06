import mms_pkg::*;
module plru_tb();
    
    logic rstn_i;
    logic clk_i;
    logic [`TLB_ENTRY_SIZE - 1 : 0] entry_valid_i;
    logic itlb_rd_hit;
    logic itlb_rd_vld;
    logic itlb_refull_init_en;
    logic itlb_refill_vld;
    logic [`TLB_ENTRY_SIZE - 1 : 0] itlb_refill_onehot_o;

    plru_32 u_plru_32 (
        // Inputs
        .clk_i               (clk_i),
        .entry_valid_i       (entry_valid_i[32-1:0]),
        .itlb_rd_hit         (itlb_rd_hit),
        .itlb_rd_vld         (itlb_rd_vld),
        .itlb_refill_vld     (itlb_refill_vld),
        .itlb_refull_init_en (itlb_refull_init_en),
        .rstn_i              (rstn_i),
        // Outputs
        .itlb_refill_onehot_o(itlb_refill_onehot_o[32-1:0])
    );
    
    
    
    initial begin
        $fsdbDumpfile("waveform.fsdb");  // Specify FSDB file name
        $fsdbDumpvars(0, tb,"+all");            // Dump all variables in the tb module
    end

    always #5 clk_i = ~clk_i;
    // Your testbench code goes here
endmodule

program testbench(
    
);
    
endprogram