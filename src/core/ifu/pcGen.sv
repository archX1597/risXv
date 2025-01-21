import risXv_macro::*;

module pcGen
    (
        input  logic                   i_rst,
        input  logic                   i_clk,
        input  logic                   i_stall,
        input  logic [`MXLEN - 1 : 0]  i_pcRedirect_pcGen_pc,
        input  logic                   i_pcRedirect_pcGen_pc_valid,
        output logic [`MXLEN - 1 : 0]  o_pcGen_cPc,o_pcGen_npc,
        output logic                   o_pcGen_npcFetch_valid
    );


    logic [`MXLEN - 1 : 0] pcGen_pc_d,pcGen_pc_q;
    logic [`MXLEN - 1 : 0] stall_pc,seq_pc,redirect_pc,boot_pc;

    assign boot_pc  = `BOOT_PC;
    assign stall_pc = pcGen_pc_q;
    assign seq_pc = (pcGen_pc_q[3:2] == 2'b00) ? pcGen_pc_q + 16:
        (pcGen_pc_q[3:2] == 2'b01) ? pcGen_pc_q + 12:
        (pcGen_pc_q[3:2] == 2'b10) ? pcGen_pc_q + 8:
        (pcGen_pc_q[3:2] == 2'b11) ? pcGen_pc_q + 4:
        pcGen_pc_q;

    assign redirect_pc = i_pcRedirect_pcGen_pc ;

    //next pc priority : i_rst > i_stall > i_redirect_pcGen_valid
    assign pcGen_pc_d  = i_rst   ? boot_pc:
        i_stall ? stall_pc:
        i_pcRedirect_pcGen_pc_valid ? redirect_pc:
        seq_pc;


    always_ff @(posedge i_clk) begin:pcGen_ff
        pcGen_pc_q <= pcGen_pc_d;
    end

    assign o_pcGen_npc = pcGen_pc_d;
    assign o_pcGen_cPc = pcGen_pc_q;
    assign o_pcGen_npcFetch_valid = (i_stall == 1'b1);
endmodule