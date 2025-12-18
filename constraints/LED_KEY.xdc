# LED[1-4]
set_property PACKAGE_PIN H9 [ get_ports {LED[0]} ]
set_property IOSTANDARD LVCMOS33 [ get_ports {LED[0]} ]
set_property DRIVE 8 [ get_ports {LED[0]} ]

set_property PACKAGE_PIN J9 [ get_ports {LED[1]} ]
set_property IOSTANDARD LVCMOS33 [ get_ports {LED[1]} ]
set_property DRIVE 8 [ get_ports {LED[1]} ]

set_property PACKAGE_PIN G11 [ get_ports "LED[2]" ]
set_property IOSTANDARD LVCMOS33 [ get_ports "LED[2]" ]
set_property DRIVE 8 [ get_ports "LED[2]" ]

set_property PACKAGE_PIN H11 [ get_ports {LED[3]} ]
set_property IOSTANDARD LVCMOS33 [ get_ports {LED[3]} ]
set_property DRIVE 8 [ get_ports {LED[3]} ]


# KEY[1-4] (really, four push buttons)
set_property IOSTANDARD LVCMOS33 [get_ports "KEY[0]"]
set_property PACKAGE_PIN K9 [get_ports "KEY[0]"]
set_property IOSTANDARD LVCMOS33 [get_ports "KEY[1]"]
set_property PACKAGE_PIN K10 [get_ports "KEY[1]"]
set_property IOSTANDARD LVCMOS33 [get_ports "KEY[2]"]
set_property PACKAGE_PIN J10 [get_ports "KEY[2]"]
set_property IOSTANDARD LVCMOS33 [get_ports "KEY[3]"]
set_property PACKAGE_PIN J11 [get_ports "KEY[3]"]


