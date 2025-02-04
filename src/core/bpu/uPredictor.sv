module uPredictor
    (
        input logic i_clk,
        input logic i_rstn,
        input logic [`MXLEN - 1 : 0] i_pcGen_nPc,i_pcGen_cPc,i_pc_jumpdst,i_pc_jumpsrc,
        input logic i_pc_valid,i_pc1_valid,i_pc2_valid,
        input logic i_ubtb_update,
        input logic i_upht_update
    );

    /*
     @WAVEDROM_START
     { signal: [
     { name: "clk",         wave: "p.....|..." },
     { name: "cPc",        wave: "x.3456..", data: ["pc0", "pc1", "pc2", "pc3"] },
     {name : "nPC",        wave: "x3456..", data: ["pc0", "pc1", "pc2", "pc3"]}
     ]}
     @WAVEDROM_END
     */

    logic [9 : 0] ghr;















    logic [`MXLEN - 1 : 0] i_pc;
    logic [`MXLEN - 1 : 0] o_targetSegment;
    logic o_target_valid;
    logic o_target_miss;

    assign i_pc = i_pcGen_nPc;
    ubtb u_ubtb (
        // Inputs
        .i_clk          (i_clk),
        .i_pc           (i_pc[32-1:0]),
        .i_pc_jumpsrc   (i_pc_jumpsrc[32-1:0]),
        .i_pc_valid     (i_pc_valid),
        .i_rstn         (i_rstn),
        .i_ubtb_update  (i_ubtb_update),
        .i_pc1_valid    (i_pc1_valid),
        .i_pc2_valid    (i_pc2_valid),
        .i_pc_jumpdst   (i_pc_jumpdst[32-1:0]),
        // Outputs
        .o_targetSegment(o_targetSegment[32-1:0]),
        .o_target_miss  (o_target_miss),
        .o_target_valid (o_target_valid)
    );

    logic i_uPhtRead_vld;
    logic i_uPhtWrite_vld;
    logic i_uPht_enable;
    logic [$clog2(`SAT_TABLE_SIZE) - 1 : 0] i_uPhtRd_addr;
    logic [$clog2(`SAT_TABLE_SIZE) - 1 : 0] i_uPhtWr_addr;
    logic [1:0] o_uPhtRd_Cnt;

    assign i_uPhtRead_vld = i_pc_valid;
    assign i_uPhtWrite_vld = i_upht_update;
    assign i_uPht_enable = 1'b1;
    assign i_uPhtRd_addr = i_pc[11:3] ^ ghr;
    upht u_upht (
        // Inputs
        // define the interface
        .i_clk          (i_clk),
        .i_commit_Cnt   (i_commit_Cnt[1:0]),
        .i_rstn         (i_rstn),
        .i_uPhtRd_addr  (i_uPhtRd_addr[$clog2(512)-1:0]),
        .i_uPhtRead_vld (i_uPhtRead_vld),
        .i_uPhtWr_addr  (i_uPhtWr_addr[$clog2(512)-1:0]),
        .i_uPhtWrite_vld(i_uPhtWrite_vld),
        .i_uPht_enable  (i_uPht_enable),
        // Outputs
        .o_uPhtRd_Cnt   (o_uPhtRd_Cnt[1:0])
    );



    property cPc_nPc_check;
        @(posedge i_clk) disable iff(~i_rstn)
            (i_pcGen_cPc == $past(i_pcGen_nPc));
    endproperty

    pc_Npc_Check:assert property(cPc_nPc_check)
    else `ERROR("cPc_nPc_check is not satisfied");



endmodule