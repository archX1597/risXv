import mms_pkg::*;
module itlb_tag
    (
        input  logic clk_i,
        input  logic rstn_i,
        input  logic tlb_flush_i,
        input  logic [`ASID_WD - 1 : 0] asid_i,
        input  logic [`VPN0_WD + `VPN1_WD - 1 : 0] tag_vpn_i,
        input  logic pte_g,
        input  logic write_en_i,
        output logic hit_o
    );

    /*
     @WAVEDROM_START
    { signal: [
    { name: "clk_i",         wave: "p........." },
    { name: "rstn_i",        wave: "010......." },
    { name: "write_en_i",    wave: "0..10....." },
    { name: "asid_i",        wave: "x.3.x4567.", data: ["2","3","2","2","2"] },
    { name: "tag_vpn_i",     wave: "x.3.x4567.", data: ["4FF","1FF","4FF","2FF","4FF"] },
    { name: "asid_q",        wave: "x...3....." ,data: ["2"] },
    { name: "tag_vpn_q",     wave: "x...3....." ,data: ["4FF"] },
    { name: "valid_q",       wave: "0...1....0" },
    { name: "hit_o",         wave: "0.....1010" },
    { name: "tlb_flush_i",   wave: "0.......10" }
    ]
    }
     @WAVEDROM_END
     */


    logic valid_q;
    //register the input
    logic [`ASID_WD - 1 : 0] asid_d, asid_q;
    vpn_t tag_vpn_d, tag_vpn_q;

    //Match
    logic asid_match;
    logic vpn1_match;
    logic vpn0_match;

    //assign the D to input
    assign asid_d = asid_i;
    assign tag_vpn_d = tag_vpn_i;

    //inscance the Register
    `D_FLIP_FLOP(asid_reg, clk_i, rstn_i, asid_d, asid_q, write_en_i);
    `D_FLIP_FLOP(tag_vpn_reg, clk_i, rstn_i, tag_vpn_d, tag_vpn_q, write_en_i);
    `D_FLIP_FLOP(valid_reg, clk_i, rstn_i, ~tlb_flush_i, valid_q, write_en_i|tlb_flush_i);


    //Match:
    assign asid_match = (asid_q == asid_i) | pte_g;
    assign vpn1_match = (tag_vpn_q.vpn1 == tag_vpn_d.vpn1);
    assign vpn0_match = (tag_vpn_q.vpn0 == tag_vpn_d.vpn0);
    assign hit_o = valid_q & asid_match & vpn1_match & vpn0_match;


//Property Check

    property itlb_tag_match;
        @(posedge clk_i) disable iff (!rstn_i)
        (valid_q & asid_match & vpn1_match & vpn0_match) |-> hit_o;
    endproperty
    property itlb_tag_flush;
        @(posedge clk_i) disable iff (!rstn_i)
        (tlb_flush_i) |-> !valid_q;
    endproperty
endmodule

