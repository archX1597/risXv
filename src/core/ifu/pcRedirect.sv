import risXv_macro::*;
`define REDIR_SRC_NUM 4
//This Component is used to arbitrate the pcRedirect request from different modules
//The priority is exu > if2 > if1 > if0
//The output is the valid signal of each 
//Combination Circuit
module pcRedirect
    (
        input  logic                  i_if0_pcRedirect_npc_valid,
        input  logic                  i_if1_pcRedirect_npc_valid,
        input  logic                  i_if2_pcRedirect_npc_valid,
        input  logic                  i_exu_pcRedirect_npc_valid,
        output logic                  o_pcIf0_RedirectArb_valid,
        output logic                  o_pcIf1_RedirectArb_valid,
        output logic                  o_pcIf2_RedirectArb_valid,
        output logic                  o_pcExu_RedirectArb_valid
    );

        //priority : exu > if2 > if1 > if0
        logic [`REDIR_SRC_NUM - 1 : 0]   Redirect_req,pcRedirectArb_valid;
        assign Redirect_req = {i_exu_pcRedirect_npc_valid,i_if2_pcRedirect_npc_valid,i_if1_pcRedirect_npc_valid,i_if0_pcRedirect_npc_valid};
        assign o_pcIf0_RedirectArb_valid = pcRedirectArb_valid[0];
        assign o_pcIf1_RedirectArb_valid = pcRedirectArb_valid[1];
        assign o_pcIf2_RedirectArb_valid = pcRedirectArb_valid[2];
        assign o_pcExu_RedirectArb_valid = pcRedirectArb_valid[3];

        always_comb begin
            unique case(Redirect_req)
                4'b1???: pcRedirectArb_valid = 4'b1000;
                4'b01??: pcRedirectArb_valid = 4'b0100;
                4'b001?: pcRedirectArb_valid = 4'b0010;
                4'b0001: pcRedirectArb_valid = 4'b0001;
                default: pcRedirectArb_valid = 4'b0000;
            endcase
        end
        


endmodule