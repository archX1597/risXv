import mms_pkg::*;
module itlb_entry(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic read_en_i,
    input  logic write_en_i,
    input  logic [`MXLEN  - 1 : 0]  pte_wr_entry_i,
    output logic [`MXLEN   - 1 : 0] pte_rd_entry_o
); 
    pte_t pte_d, pte_q;
    `D_FLIP_FLOP(pte_reg, clk_i, rstn_i, pte_d, pte_q, write_en_i);
    assign pte_d = pte_wr_entry_i;
    assign pte_rd_entry_o = read_en_i ? pte_q : '0;
    
    //*****************************Property Check Start******************************// 
    //: if (read_en_i) pte_rd_entry_o is onehot signal//

    property p_one_hot_check;
        @(posedge clk_i) disable iff (!rstn_i)
        read_en_i |-> $onehot(pte_rd_entry_o);
    endproperty
    //Assertion
    assert property (p_one_hot_check) else $error("Error: pte_rd_entry_o is not onehot");
    //******************************Check End***************************************//

endmodule