.PHONY: view

view:
	gtkwave $(TOP_MODULE).gtkw

viewvcd:
	gtkwave $(TOP_MODULE).vcd