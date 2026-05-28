.PHONY: all
all: liteeth_core.v liteeth_core.vhdl

# generate liteeth core
liteeth_core.v: XCKUP5P-RGMII.yaml
	liteeth_gen --gateware-dir . --no-compile-software $<
	# adapt for ULTRASCALE_PLUS architecture
	sed -i -e 's/"ULTRASCALE"/"ULTRASCALE_PLUS"/g' liteeth_core.v
	sed -i 's/\[get_nets /[get_nets liteeth_core_0\//g' liteeth_core.xdc
	echo "" >> liteeth_core.xdc
	echo "" >> liteeth_core.xdc
	echo "set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports eth_txd[1]]" >> liteeth_core.xdc

# generate VHDL instantiation template
liteeth_core.vhdl: liteeth_core.v
	python3 ../../../utils/pyVHDLinstTemplate/pyVHDLinstTemplate.py liteeth_core.v

# clean generated files
.PHONY: clean
clean:
	rm -f liteeth_core.v
	rm -f liteeth_core.vhdl
	rm -f liteeth_core.xdc
	rm -f liteeth_core.tcl
	rm -f build_liteeth_core.sh
	rm -rf build




