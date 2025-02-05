import risXv_macro::*;
`define REDIR_SRC_NUM 4
//This Component is used to arbitrate the pcRedirect request from different modules
//The priority is exu > if2 > if1 > if0
//The output is the valid signal of each
//Combination Circuit
module pcRedirect
    (

        input  logic  [`MXLEN - 1 : 0]  i_if0_pcRedirect_npc,
        input  logic  [`MXLEN - 1 : 0]  i_if1_pcRedirect_npc,
        input  logic  [`MXLEN - 1 : 0]  i_if2_pcRedirect_npc,
        input  logic  [`MXLEN - 1 : 0]  i_exu_pcRedirect_npc,
        //valid signal of each module
        input  logic                    i_if0_pcRedirect_npc_valid,
        input  logic                    i_if1_pcRedirect_npc_valid,
        input  logic                    i_if2_pcRedirect_npc_valid,
        input  logic                    i_exu_pcRedirect_npc_valid,
        output logic   [`MXLEN - 1 : 0] o_pcRedirect_npcGen_npc,
        output logic                    o_pcRedirect_npcGen_redirect_valid
    );

    //priority : exu > if2 > if1 > if
    always_comb begin
        if(i_exu_pcRedirect_npc_valid) begin
            o_pcRedirect_npcGen_npc = i_exu_pcRedirect_npc;
        end
        else if(i_if2_pcRedirect_npc_valid) begin
            o_pcRedirect_npcGen_npc = i_if2_pcRedirect_npc;
        end
        else if(i_if1_pcRedirect_npc_valid) begin
            o_pcRedirect_npcGen_npc = i_if1_pcRedirect_npc;
        end
        else if(i_if0_pcRedirect_npc_valid) begin
            o_pcRedirect_npcGen_npc = i_if0_pcRedirect_npc;
        end
        else begin
            o_pcRedirect_npcGen_npc = 'h0;
        end
    end

    assign o_pcRedirect_npcGen_redirect_valid = i_exu_pcRedirect_npc_valid |
                                                i_if2_pcRedirect_npc_valid |
                                                i_if1_pcRedirect_npc_valid |
                                                i_if0_pcRedirect_npc_valid;

    //Proerty Check
    //1. Check The Priority of the pcRedirect
   /*property pcRedirect_priority;
        (i_exu_pcRedirect_npc_valid && !i_if2_pcRedirect_npc_valid && !i_if1_pcRedirect_npc_valid && !i_if0_pcRedirect_npc_valid) | 
        (!i_exu_pcRedirect_npc_valid && i_if2_pcRedirect_npc_valid && !i_if1_pcRedirect_npc_valid && !i_if0_pcRedirect_npc_valid) |
        (!i_exu_pcRedirect_npc_valid && !i_if2_pcRedirect_npc_valid && i_if1_pcRedirect_npc_valid && !i_if0_pcRedirect_npc_valid) |
        (!i_exu_pcRedirect_npc_valid && !i_if2_pcRedirect_npc_valid && !i_if1_pcRedirect_npc_valid && i_if0_pcRedirect_npc_valid);
    endproperty

    assert property(pcRedirect_priority)
    else $error("pcRedirect_priority is not satisfied");*/
endmodule
