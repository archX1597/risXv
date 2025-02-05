import risXv_macro::*;

module pcGen
    (
        input  logic                   i_rstn,
        input  logic                   i_clk,
        input  logic                   i_stall,
        input  logic [`MXLEN - 1 : 0]  i_pcRedirect_pcGen_pc,
        input  logic                   i_pcRedirect_pcGen_pc_valid,
        output logic [`MXLEN - 1 : 0]  o_pcGen_cPc,
        output logic [`MXLEN - 1 : 0]  o_pcGen_nPc,
        output logic                   o_pcGen_nPcFetch_valid
    );



    logic [`MXLEN - 1 : 0] pcGen_pc_d,pcGen_pc_q;
    logic [`MXLEN - 1 : 0] stall_pc,seq_pc,redirect_pc,boot_pc;

    assign boot_pc  = `BOOT_PC;
    assign stall_pc = pcGen_pc_q;
    assign seq_pc   = (pcGen_pc_q[3:2] == 2'b01) ? pcGen_pc_q + 4:
                                      (pcGen_pc_q[3:2] == 2'b11) ? pcGen_pc_q + 4:
                                      (pcGen_pc_q[3:2] == 2'b00) ? pcGen_pc_q + 8:
                                      (pcGen_pc_q[3:2] == 2'b10) ? pcGen_pc_q + 8:
                                       pcGen_pc_q;

    assign redirect_pc = i_pcRedirect_pcGen_pc ;

    //next pc priority : i_rstn > i_stall > i_redirect_pcGen_valid
    assign pcGen_pc_d  = ~i_rstn   ? boot_pc:
        i_stall  ? stall_pc:
        i_pcRedirect_pcGen_pc_valid ? redirect_pc:
        seq_pc;



    `FLIP_FLOP_ASYNC_RESET(pcGen_pc, i_clk, i_rstn, pcGen_pc_d,pcGen_pc_q, 1'b1);



    assign o_pcGen_nPc = pcGen_pc_d;
    assign o_pcGen_cPc = pcGen_pc_q;
    assign o_pcGen_nPcFetch_valid = (i_stall == 1'b0);




    //Proerty Check
    property pcGen_npcFetch_valid;
        @(posedge i_clk)
        disable iff(i_rstn)
        (i_stall == 1'b0) |-> o_pcGen_nPcFetch_valid;
    endproperty

    property iRST_Priority_Check;
        @(posedge i_clk) i_rstn |-> (boot_pc == o_pcGen_nPc);
    endproperty

    property Stall_Priority_Check;
        @(posedge i_clk) ~i_rstn&&i_stall |-> (stall_pc == o_pcGen_nPc);
    endproperty

    property Redirect_Priority_Check;
        @(posedge i_clk) ~i_rstn&&~i_stall&&i_pcRedirect_pcGen_pc_valid |-> (redirect_pc == o_pcGen_nPc);
    endproperty

    PCvaid_assert:assert property(pcGen_npcFetch_valid)
    else $error("pcGen_npcFetch_valid is not satisfied");
    irst_assert:assert property(iRST_Priority_Check)
    else $error("iRST_Priority_Check is not satisfied");
    stall_assert:assert property(Stall_Priority_Check)
    else $error("Stall_Priority_Check is not satisfied");
    redirect_assert:assert property(Redirect_Priority_Check)
    else $error("Redirect_Priority_Check is not satisfied");
endmodule