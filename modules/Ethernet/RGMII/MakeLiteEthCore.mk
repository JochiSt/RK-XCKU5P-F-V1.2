.PHONY: all
all: liteeth_core.v liteeth_core.vhdl

# generate liteeth core
liteeth_core.v: XCKUP5P-RGMII.yaml
	liteeth_gen --gateware-dir . --no-compile-software $<

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




