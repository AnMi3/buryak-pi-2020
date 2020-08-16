create_clock -name "CLK28" -period 28MHz [get_ports {CLK28}]
create_clock -name "KEY_SCK" -period 16MHz [get_ports {KEY_SCK}]
create_clock -name "N_M1" -period 7MHz [get_ports {N_M1}]
create_clock -name "TURBO" -period 1Hz [get_ports {cpld_kbd:U4|O_TURBO}]

create_generated_clock -name "clk_14" -divide_by 2 -source [get_ports {CLK28}]
create_generated_clock -name "clk_7" -divide_by 4 -source [get_ports {CLK28}]
create_generated_clock -name "clkcpu" -divide_by 4 -source [get_ports {CLK28}]

derive_clock_uncertainty

set_false_path -from [get_clocks {KEY_SCK}] -to [get_clocks {CLK28}]
set_false_path -from [get_clocks {CLK28}] -to [get_clocks {KEY_SCK}]

set_clock_groups -exclusive -group {CLK28} -group {KEY_SCK}
