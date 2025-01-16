module CntRevise (
    input  logic clk_i,
    input  logic rstn_i,
    input  logic update_i,
    input  logic br_taken_i,
    input  logic [1:0] ori_cnt_i,
    output logic [1:0] updated_cnt_i 
);  

    logic [1:0] cnt_d,cnt_q;
    assign cnt_d = ori_cnt_i;
    
    `D_FLIP_FLOP(CntRevise_reg, clk_i, rstn_i, cnt_d, cnt_q, update_i)
    
    always_comb begin
        if(br_taken_i == 1'b1) begin
            if(cnt_q == 2'b11) begin
                updated_cnt_i = 2'b11;
            end
            else begin
                updated_cnt_i = cnt_q + 1;
            end
        end
        else begin
            if(cnt_q == 2'b00) begin
                updated_cnt_i = 2'b00;
            end
            else begin
                updated_cnt_i = cnt_q - 1;
            end
        end
    end                   

    // Internal signals
endmodule