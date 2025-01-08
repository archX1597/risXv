package risXv_macro;
`define MXLEN 32
`define DATA_WD 32
`define INST_WD 32


`define D_FLIP_FLOP(name, clk, rst, d, q,en) \
    always_ff @(posedge clk or negedge rst) begin:name \
        if (!rst) begin \
            q <= 'b0; \
        end else if(en) begin \
            q <= d; \
        end \
    end
endpackage
