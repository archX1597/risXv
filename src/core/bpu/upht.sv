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

    usat_entry_t sat_table_d [$clog2(`SAT_TABLE_SIZE)-1:0];
    usat_entry_t sat_table_q [$clog2(`SAT_TABLE_SIZE)-1:0];

    //Define the Dual Port RAM of Sat_table

    always_comb begin:Saturaion_table_update
        if(i_uPhtWrite_vld) begin
            sat_table_d[i_uPhtWr_addr].sat_counter = i_commit_Cnt;
            sat_table_d[i_uPhtWr_addr].valid = 1'b1;
        end
        else begin
            sat_table_d[i_uPhtWr_addr].sat_counter = sat_table_q[i_uPhtWr_addr].sat_counter;
            sat_table_d[i_uPhtWr_addr].valid = sat_table_q[i_uPhtWr_addr].valid;
        end
    end

    //always_ff 
    always_ff @(posedge i_clk or negedge i_rstn) begin:Sat_table_ram
        for (int i = 0; i < `SAT_TABLE_SIZE; i++) begin
            if(~i_rstn) begin
                sat_table_q[i].sat_counter <= 2'b10;
                sat_table_q[i].valid <= 1'b0;
            end
            else if(i_uPht_enable) begin
                sat_table_q[i].sat_counter <= sat_table_d[i].sat_counter;
                sat_table_q[i].valid <= sat_table_d[i].valid;
            end
        end
    end


    assign o_uPhtRd_Cnt = i_uPhtRead_vld ? sat_table_q[i_uPhtRd_addr].sat_counter : 2'b10;

    property Sat_table_update;
        @(posedge i_clk)
        disable iff(~i_uPht_enable | ~i_uPhtWrite_vld | ~i_rstn)
        (i_uPhtWrite_vld) |=> (sat_table_d[$past(i_uPhtWr_addr)].sat_counter == $past(i_commit_Cnt));
    endproperty

    assert property(Sat_table_update)
    else `ERROR("Sat_table_update is not satisfied");

    property Sat_table_read;
        @(posedge i_clk)
        disable iff(~i_uPht_enable | ~i_uPhtRead_vld | ~i_rstn)
        (i_uPhtRead_vld) |-> (o_uPhtRd_Cnt == sat_table_q[i_uPhtRd_addr].sat_counter);
    endproperty

    assert property(Sat_table_read)
    else `ERROR("Sat_table_read is not satisfied");

endmodule

