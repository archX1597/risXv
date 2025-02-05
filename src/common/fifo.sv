//a Sync Fifo
module sync_fifo #(
    parameter  DATA_WIDTH = 8,                     // Data width
    parameter  FIFO_DEPTH = 16,                    // FIFO depth (suggested to be a power of 2)
    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH)       // Address width computed from FIFO_DEPTH
  )(
    input  logic                      i_clk,      // Clock
    input  logic                      i_rstn,     // Asynchronous active-low reset
    input  logic                      i_write,    // Write enable (synchronous write, takes effect on the next clock edge)
    input  logic                      i_read,     // Read enable (combinational read)
    input  logic [DATA_WIDTH-1:0]     i_data,     // Data input for writing
    output logic [DATA_WIDTH-1:0]     o_data,     // Data output (combinational read)
    output logic                      o_full,     // FIFO full flag
    output logic                      o_empty     // FIFO empty flag
  );
  
    // Internal FIFO memory array
    logic [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
  
    // Read pointer, write pointer, and FIFO counter (counts number of stored entries)
    logic [ADDR_WIDTH-1:0] r_ptr;
    logic [ADDR_WIDTH-1:0] w_ptr;
    logic [ADDR_WIDTH:0]   cnt; // Extra bit to count up to FIFO_DEPTH
  
    // -------------------------------------------------------
    // Combinational logic using continuous assignments
    // -------------------------------------------------------
    assign o_empty = (cnt == 0);       // FIFO is empty when count is zero
    assign o_full  = (cnt == FIFO_DEPTH); // FIFO is full when count equals FIFO_DEPTH
    assign o_data  = mem[r_ptr];        // Read data is taken directly from the memory at the read pointer
  
    // -------------------------------------------------------
    // Sequential logic (one always_ff per signal)
    // -------------------------------------------------------
  
    // 1. Memory write block (updates the memory array)
    //    No memory clear logic on reset
    always_ff @(posedge i_clk or negedge i_rstn) begin
      if (!i_rstn) begin
        // Do not clear memory on reset
      end
      else begin
        if (i_write && !o_full)
          mem[w_ptr] <= i_data;
      end
    end
  
    // 2. Write pointer update block (updates w_ptr)
    always_ff @(posedge i_clk or negedge i_rstn) begin
      if (!i_rstn)
        w_ptr <= '0;
      else begin
        if (i_write && !o_full)
          w_ptr <= w_ptr + 1;
      end
    end
  
    // 3. Read pointer update block (updates r_ptr)
    always_ff @(posedge i_clk or negedge i_rstn) begin
      if (!i_rstn)
        r_ptr <= '0;
      else begin
        if (i_read && !o_empty)
          r_ptr <= r_ptr + 1;
      end
    end
  
    // 4. FIFO counter update block (updates cnt)
    //    The counter increments on a write without a simultaneous read,
    //    decrements on a read without a simultaneous write,
    //    and holds its value if both or neither occur.
    always_ff @(posedge i_clk or negedge i_rstn) begin
      if (!i_rstn)
        cnt <= '0;
      else begin
        if ((i_write && !o_full) && !(i_read && !o_empty))
          cnt <= cnt + 1;
        else if (!(i_write && !o_full) && (i_read && !o_empty))
          cnt <= cnt - 1;
        else
          cnt <= cnt;
      end
    end
  
  endmodule
  