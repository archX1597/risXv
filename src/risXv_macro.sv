package risXv_macro;
`define MXLEN 32
`define DATA_WD 32
`define INST_WD 32


`define FLIP_FLOP_ASYNC_RESET(name, clk, rst, d, q,en) \
    always_ff @(posedge clk or negedge rst) begin:name \
        if (!rst) begin \
            q <= 'b0; \
        end else if(en) begin \
            q <= d; \
        end \
    end
`define FLIP_FLOP_NOT_RESET(name, clk, d, q) \
    always_ff @(posedge clk) begin:name \
        q <= d; \
    end
`define FLIP_FLOP_SYNC_RESET(name, clk, rst, d, q) \
    always_ff @(posedge clk) begin:name \
        if (rst) begin \
            q <= 'b0; \
        end else begin \
            q <= d; \
        end \
    end
`define BOOT_PC 32'h00000000;
endpackage
