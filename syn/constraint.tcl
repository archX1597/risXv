set clk_period 0.25
create_clock -period $clk_period [get_ports clk_i]

set_input_delay 0.005 -clock clk_i [all_inputs]
set_output_delay 0.005 -clock clk_i [all_outputs]

set_drive 1 [all_inputs]
set_load 0.1 [all_outputs]