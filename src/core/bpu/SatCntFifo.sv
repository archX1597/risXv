module SatCntFifo(
    input  logic        i_clk,
    input  logic        i_rstn,
    input  logic        i_SatCntFIFO_Read,
    input  logic        i_SatCntFIFO_Write,
    input  logic  [1:0] i_SatCntFIFO_WrCnt,
    output logic  [1:0] o_SatCntFIFO_RdCnt,
    output logic        o_SatCnt_Miss,
    output logic        o_SatCnt_Full
);

    parameter DATA_WIDTH = 2; 
    parameter FIFO_DEPTH = 8;

    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )
    u_sync_fifo (
        // Inputs
        .i_clk  (i_clk),
        .i_data (i_SatCntFIFO_WrCnt), //Data input for writing
        .i_read (i_SatCntFIFO_Read), //Read enable (combinational read)
        .i_rstn (i_rstn), //Asynchronous active-low reset
        .i_write(i_SatCntFIFO_Write), //Write enable (synchronous write, takes effect on the next clock edge)
        // Outputs
        .o_data (o_SatCntFIFO_RdCnt), //Data output (combinational read)
        .o_empty(o_SatCnt_Miss), //FIFO empty flag
        .o_full (o_SatCnt_Full) //FIFO full flag
    );

endmodule