.PHONY: ghdlana ghdlclean

ifeq ($(strip $(TOOL_PATH)),)
TOOL_PATH := $(shell dirname `which vivado`)
endif

# move packages to front of source file list
SOURCES_VHDLFiles  = $(shell grep "vhd" files.tcl | cut -d " " -f 3 | cut -d ";" -f 1 | grep "pkg")
SOURCES_VHDLFiles += $(shell grep "vhd" files.tcl | cut -d " " -f 3 | cut -d ";" -f 1 | grep -v "pkg" )

ghdlana: files.tcl unisim-obj93.cf
	mkdir -p ghdl
	ghdl -a -fsynopsys -fexplicit -Punisim --workdir=ghdl $(SOURCES_VHDLFiles)

ghdlclean:
	rm -f *.o
	rm -f *.cf
	rm -f ghdl/*

hiertree:
	yosys -m ghdl -p "ghdl -fsynopsys -fexplicit -Punisim --workdir=ghdl $(TOP_MODULE); show;" \

# ghdl -e --workdir=ghdl -fsynopsys --std=93c $(TOP_MODULE)

##############################################################################
# Xilinx UNISIM
unisim-obj93.cf:
	ghdl -a --work=unisim -fsynopsys $(TOOL_PATH)/../data/vhdl/src/unisims/unisim_VCOMP.vhd
	ghdl -a --work=unisim -fsynopsys $(TOOL_PATH)/../data/vhdl/src/unisims/unisim_VPKG.vhd
