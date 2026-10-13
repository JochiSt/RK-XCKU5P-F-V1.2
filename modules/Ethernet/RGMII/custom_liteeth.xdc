set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports eth_txd[1]]

################################################################################
# False path constraints
################################################################################

set_false_path -quiet -to [get_cells -hierarchical -filter {mr_ff == TRUE}]
set_false_path -quiet -to [get_pins -filter {REF_PIN_NAME == PRE} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE || ars_ff2 == TRUE}]]
set_max_delay 2 -quiet -from [get_pins -filter {REF_PIN_NAME == C} -of_objects [get_cells -hierarchical -filter {ars_ff1 == TRUE}]] -to [get_pins -filter {REF_PIN_NAME == D} -of_objects [get_cells -hierarchical -filter {ars_ff2 == TRUE}]]

set_clock_groups -group [get_clocks -of [get_nets liteeth_core_0\/sys_clk]] -group [get_clocks -of [get_nets eth_rxc]] -asynchronous
set_clock_groups -group [get_clocks -of [get_nets liteeth_core_0\/sys_clk]] -group [get_clocks -of [get_nets eth_txc]] -asynchronous
set_clock_groups -group [get_clocks -of [get_nets eth_rxc]] -group [get_clocks -of [get_nets eth_txc]] -asynchronous