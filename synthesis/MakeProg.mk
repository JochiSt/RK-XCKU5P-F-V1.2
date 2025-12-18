.PHONY: prog

prog: bitstream
	openFPGALoader --cable digilent --detect
	openFPGALoader --cable digilent $(PROJECT).runs/impl_1/$(TOP_MODULE).bit
	@date
