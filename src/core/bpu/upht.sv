import bpu_pkg::*;
//`define UVM_OPT
module upht(
    //define the interface
    input  logic                                   i_clk,
    input  logic                                   i_rstn,
    input  logic                                   i_uPhtRead_vld,
    input  logic                                   i_uPhtWrite_vld,
    input  logic                                   i_uPht_enable,
    input  logic [$clog2(`SAT_TABLE_SIZE) - 1 : 0] i_uPhtRd_addr,i_uPhtWr_addr,
    input  logic [1:0]                             i_commit_Cnt,
    output logic [1:0]                             o_uPhtRd_Cnt
);

    logic [1:0]  sat_table_d [`SAT_TABLE_SIZE-1:0];
    logic [1:0]  sat_table_q [`SAT_TABLE_SIZE-1:0];
    logic sat_table_vld_q [`SAT_TABLE_SIZE-1:0];
    logic sat_table_vld_d [`SAT_TABLE_SIZE-1:0];
    //Define the Dual Port RAM of Sat_table

    always_comb begin:Saturaion_table_update
        for(int i = 0; i < `SAT_TABLE_SIZE; i++) begin
            sat_table_d[i] = (i==i_uPhtWr_addr)&&i_uPhtWrite_vld ? i_commit_Cnt : sat_table_q[i];
            sat_table_vld_d[i] = (i==i_uPhtWr_addr)&&i_uPhtWrite_vld ? 1'b1 : sat_table_vld_q[i];
        end
    end

    //always_ff 
    always_ff @(posedge i_clk or negedge i_rstn) begin:Sat_table_ram
        for (int i = 0; i < `SAT_TABLE_SIZE; i++) begin
            if(~i_rstn) begin
                sat_table_q[i] <= 2'b01;
                sat_table_vld_q[i] <= 1'b0;
            end
            else if(i_uPht_enable) begin
                sat_table_q[i] <= sat_table_d[i];
                sat_table_vld_q[i] <= sat_table_vld_d[i];
            end
        end
    end


    assign o_uPhtRd_Cnt = i_uPhtRead_vld ? sat_table_q[i_uPhtRd_addr] : 2'b10;

    property Sat_table_update;
        @(posedge i_clk)
        disable iff(~i_uPht_enable | ~i_uPhtWrite_vld | ~i_rstn)
        (i_uPhtWrite_vld) |=> (sat_table_d[$past(i_uPhtWr_addr)] == $past(i_commit_Cnt));
    endproperty

    assert property(Sat_table_update)
    else `ERROR("Sat_table_update is not satisfied");

    property Sat_table_read;
        @(posedge i_clk)
        disable iff(~i_uPht_enable | ~i_uPhtRead_vld | ~i_rstn)
        (i_uPhtRead_vld) |-> (o_uPhtRd_Cnt == sat_table_q[i_uPhtRd_addr]);
    endproperty

    assert property(Sat_table_read)
    else `ERROR("Sat_table_read is not satisfied");

endmodule

