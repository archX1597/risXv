import bpu_pkg::*;
module PipeIF0(
    input logic                         i_clk,
    input logic                         i_rstn,
    input logic                         i_stall,
    input logic [`MXLEN - 1 : 0]        i_if1_pcRedirect_npc,
    input logic [`MXLEN - 1 : 0]        i_if2_pcRedirect_npc,
    input logic [`MXLEN - 1 : 0]        i_exu_pcRedirect_npc,
    input logic                         i_if1_pcRedirect_npc_valid,
    input logic                         i_if2_pcRedirect_npc_valid,
    input logic                         i_exu_pcRedirect_npc_valid,
    input logic [`MXLEN - 1 : 0]        i_pc_jumpdst,
    input logic [`MXLEN - 1 : 0]        i_pc_jumpsrc,
    input logic                         i_ubtb_update,
    input logic                         i_upht_update,
    input logic                         i_ghr_update,
    input logic                         i_satCnt_update,
    input logic                         i_last_jump,
    //output Port
    output logic                        o_pcGen_nPcFetch_valid,
    output logic [`MXLEN - 1 : 0]       o_pcGen_cPc
);      


    logic [`MXLEN - 1 : 0] i_pcRedirect_pcGen_pc;
    logic i_pcRedirect_pcGen_pc_valid;
    logic [`MXLEN - 1 : 0] o_pcGen_nPc;
    logic [`MXLEN - 1 : 0] i_if0_pcRedirect_npc;
    logic i_if0_pcRedirect_npc_valid;
    logic [`MXLEN -1  : 0] o_pcRedirect_npcGen_npc;
    logic o_pcRedirect_npcGen_redirect_valid;


    assign i_pcRedirect_pcGen_pc = o_pcRedirect_npcGen_npc;
    assign i_pcRedirect_pcGen_pc_valid = o_pcRedirect_npcGen_redirect_valid;

    pcRedirect u_pcRedirect (
        // Inputs
        .i_exu_pcRedirect_npc              (i_exu_pcRedirect_npc[`MXLEN-1:0]),
        .i_exu_pcRedirect_npc_valid        (i_exu_pcRedirect_npc_valid),
        .i_if0_pcRedirect_npc              (i_if0_pcRedirect_npc[`MXLEN-1:0]),
        // valid signal of each module
        .i_if0_pcRedirect_npc_valid        (i_if0_pcRedirect_npc_valid),
        .i_if1_pcRedirect_npc              (i_if1_pcRedirect_npc[`MXLEN-1:0]),
        .i_if1_pcRedirect_npc_valid        (i_if1_pcRedirect_npc_valid),
        .i_if2_pcRedirect_npc              (i_if2_pcRedirect_npc[`MXLEN-1:0]),
        .i_if2_pcRedirect_npc_valid        (i_if2_pcRedirect_npc_valid),
        // Outputs
        .o_pcRedirect_npcGen_npc           (o_pcRedirect_npcGen_npc),
        .o_pcRedirect_npcGen_redirect_valid(o_pcRedirect_npcGen_redirect_valid)
    );


    pcGen u_pcGen (
        // Inputs
        .i_clk                      (i_clk),
        .i_pcRedirect_pcGen_pc      (i_pcRedirect_pcGen_pc[`MXLEN-1:0]),
        .i_pcRedirect_pcGen_pc_valid(i_pcRedirect_pcGen_pc_valid),
        .i_rstn                     (i_rstn),
        .i_stall                    (i_stall),
        // Outputs
        .o_pcGen_cPc                (o_pcGen_cPc[`MXLEN-1:0]),
        .o_pcGen_nPc                (o_pcGen_nPc[`MXLEN-1:0]),
        .o_pcGen_nPcFetch_valid     (o_pcGen_nPcFetch_valid)
    );


    logic [`MXLEN - 1 : 0] i_pcGen_nPc;
    logic [`MXLEN - 1 : 0] i_pcGen_cPc;
    logic i_nPc_valid;
    logic i_pc1_valid;
    logic i_pc2_valid;
    logic o_uPreJump;
    logic if0_valid;
    logic [`MXLEN - 1 : 0] o_uPreTarget;

    assign i_pcGen_nPc = o_pcGen_nPc;
    assign i_pcGen_cPc = o_pcGen_cPc;
    assign i_nPc_valid  = 1'b1;
    assign i_pc1_valid = 1'b1;
    // PC must aligne to 8 bytes
    assign i_pc2_valid = (o_pcGen_cPc[2:0] == 3'b000);
    // uPredictor output must commit to pcRedirect input
    assign i_if0_pcRedirect_npc_valid = o_uPreJump;
    assign i_if0_pcRedirect_npc       = o_uPreTarget;

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if(~i_rstn) begin
            if0_valid <= 1'b0;
        end
        else if(!i_stall)begin
            if0_valid <= i_nPc_valid;
        end
    end

    uPredictor u_uPredictor (
        // Inputs
        .i_clk          (i_clk),
        .i_ghr_update   (i_ghr_update),
        .i_last_jump    (i_last_jump),
        .i_pc1_valid    (i_pc1_valid),
        .i_pc2_valid    (i_pc2_valid),
        .i_if0_valid    (if0_valid),
        .i_pcGen_cPc    (i_pcGen_cPc[`MXLEN-1:0]),
        .i_pcGen_nPc    (i_pcGen_nPc[`MXLEN-1:0]),
        .i_pc_jumpdst   (i_pc_jumpdst[`MXLEN-1:0]),
        .i_pc_jumpsrc   (i_pc_jumpsrc[`MXLEN-1:0]),
        .i_nPc_valid    (i_nPc_valid),
        .i_rstn         (i_rstn),
        .i_satCnt_update(i_satCnt_update),
        .i_ubtb_update  (i_ubtb_update),
        .i_upht_update  (i_upht_update),
        // Outputs
        .o_uPreJump     (o_uPreJump),
        .o_uPreTarget   (o_uPreTarget[`MXLEN-1:0])
    );
endmodule