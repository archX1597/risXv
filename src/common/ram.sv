module SyncRam1r1w
    #( parameter RAM_DATA_WIDTH = 32,
       parameter RAM_DEPTH      = 512,
       localparam RAM_ADDR_WIDTH = $clog2(RAM_DEPTH)
    )
    (
        input  logic clk,
        input  logic we,
        input  logic re,
        input  logic i_rstn,
        input  logic [RAM_ADDR_WIDTH-1:0] waddr,
        input  logic [RAM_ADDR_WIDTH-1:0] raddr,
        input  logic [RAM_DATA_WIDTH-1:0] wdata,
        output logic [RAM_DATA_WIDTH-1:0] rdata
    );

    logic [RAM_DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];

    always_ff @(posedge clk or negedge i_rstn) begin
        if(~i_rstn) begin
            for(int i = 0; i < RAM_DEPTH; i++) begin
                mem[i] <= 0;
            end
        end
        else if(we) begin
            mem[waddr] <= wdata;
        end
    end

    always_ff @(posedge clk) begin
        if(re) begin
            rdata <= mem[raddr];
        end
    end
endmodule