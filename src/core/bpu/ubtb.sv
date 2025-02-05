import bpu_pkg::*;
module ubtb(
    input  logic i_rstn,
    input  logic i_clk,
    input  logic i_ubtb_update,
    input  logic i_pc_valid,
    input  logic [`MXLEN - 1 : 0] i_pc,i_pc_jumpsrc,
    input  logic [`MXLEN - 1 : 0] i_pc_jumpdst,
    input  logic i_pc1_valid,i_pc2_valid,
    output logic [`MXLEN - 1 : 0] o_targetSegment,
    output logic o_target_valid,
    output logic o_target_miss
); 

    // Define the BTB table
    // Dual Port Ram For Read and Write

    pc_uPrehash_t pc1_Prehash,pc2_Prehash,pc_jumpsrc_Prehash;
    pc_uAfthash_t pc1_Afthash,pc2_Afthash,pc_jumpsrc_Afthash;
    ubtb_instEntry_t btb_InstRd,btb_InstWr;
    ubtb_tagEntry_t  btb_TagRd,btb_TagWr;
    logic [`uBTB_DEPTH - 1 : 0] valid;
    logic [`uBTB_INDEX_LEN - 1 : 0] pc_index_ff;
    logic [`uHASH_LEN - 1 : 0] pc1_hash,pc2_hash;

    assign pc1_Prehash = i_pc; 
    assign pc2_Prehash = pc1_Prehash + 4;
    assign pc_jumpsrc_Prehash = i_pc_jumpsrc;

    // hash the pc

    assign pc1_Afthash.pc_hashTag = pc1_Prehash.pc_Part0 ^ pc1_Prehash.pc_Part1;
    assign pc1_Afthash.pc_index = pc1_Prehash.pc_index;
    assign pc2_Afthash.pc_hashTag = pc2_Prehash.pc_Part0 ^ pc2_Prehash.pc_Part1;
    assign pc2_Afthash.pc_index = pc2_Prehash.pc_index;
    assign pc_jumpsrc_Afthash.pc_hashTag = pc_jumpsrc_Prehash.pc_Part0 ^ pc_jumpsrc_Prehash.pc_Part1;
    assign pc_jumpsrc_Afthash.pc_index = pc_jumpsrc_Prehash.pc_index;
    assign btb_TagWr.tag =pc_jumpsrc_Afthash.pc_hashTag;
    //Valid RAM for Read and Write
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if(~i_rstn) begin
            valid <= 0;
        end
        else if(i_ubtb_update) begin
            valid[pc_jumpsrc_Afthash.pc_index] <= 1;
        end
        else begin
            valid[pc_jumpsrc_Afthash.pc_index] <= valid[pc_jumpsrc_Afthash.pc_index];
        end
    end

    //pc_index_ff

    always_ff @(posedge i_clk or negedge i_rstn) begin
        if(~i_rstn) begin
            pc_index_ff <= 0;
        end
        else begin
            pc_index_ff <= pc1_Afthash.pc_index;
        end
    end

    //pc_hash_ff
    always_ff @(posedge i_clk or negedge i_rstn) begin
        if(~i_rstn) begin
            pc1_hash <= 0;
            pc2_hash <= 0;
        end
        else begin
            pc1_hash <= pc1_Afthash.pc_hashTag;
            pc2_hash <= pc2_Afthash.pc_hashTag;
        end
    end
    // Dual Port RAM for Read and Write 
    // BTA
    // Branch Tag Array
    SyncRam1r1w #(
        .RAM_DATA_WIDTH(`uTAG_LEN),
        .RAM_DEPTH     (`uBTB_DEPTH)
    )
    u_Btb_TagArray (
        // Inputs
        .clk  (i_clk),
        .i_rstn(i_rstn),
        .raddr(pc1_Afthash.pc_index),
        .re   (i_pc_valid),
        .waddr(pc_jumpsrc_Afthash.pc_index),
        .wdata(btb_TagWr.tag),
        .we   (i_ubtb_update),
        // Outputs
        .rdata(btb_TagRd.tag)
    );

    // BIA

    SyncRam1r1w #(
        .RAM_DATA_WIDTH(`uINST_OFFSETLEN),
        .RAM_DEPTH     (`uBTB_DEPTH)
    )
    u_Btb_InstArray (
        // Inputs
        .clk  (i_clk),
        .i_rstn(i_rstn),
        .raddr(pc1_Afthash.pc_index),
        .re   (i_pc_valid),
        .waddr(pc_jumpsrc_Afthash.pc_index),
        .wdata(btb_InstWr.inst_offset),
        .we   (i_ubtb_update),
        // Outputs
        .rdata(btb_InstRd.inst_offset)
    );

    assign btb_InstWr.inst_offset = i_pc_jumpdst;
    assign btb_TagRd.valid = valid[pc_index_ff];
    assign o_target_valid  = 
    btb_TagRd.valid && (btb_TagRd.tag == pc1_hash) && i_pc1_valid |
    btb_TagRd.valid && (btb_TagRd.tag == pc2_hash) && i_pc2_valid;
    assign o_target_miss   = 
    btb_TagRd.valid && (btb_TagRd.tag != pc1_hash) && i_pc1_valid |
    btb_TagRd.valid && (btb_TagRd.tag != pc2_hash) && i_pc2_valid |
    ~btb_TagRd.valid;

    assign o_targetSegment = o_target_valid ? btb_InstRd.inst_offset : 0;
endmodule