// Testbench file with clock generation and Verdi system functions
`timescale 1ns/1ps

module tb;

    // Clock signal declaration
    reg clk;
    initial clk = 0;

    // Clock generation: 50% duty cycle, 10ns period
    always #5 clk = ~clk;

    // Verdi system functions for waveform dumping
    initial begin
        $fsdbDumpfile("waveform.fsdb");  // Specify FSDB file name
        $fsdbDumpvars(0, tb);            // Dump all variables in the tb module
    end

    // Your testbench code goes here

endmodule
