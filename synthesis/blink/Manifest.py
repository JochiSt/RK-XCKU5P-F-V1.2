action="synthesis"
target="xilinx"

# include other makefiles
incl_makefiles = [
    "../MakeProg.mk",       # for programming the FPGA
    "../../MakeClean.mk",   # for advanced cleaning
    "../../MakeGHDLana.mk"  # for GHDL analysis
]

# use VIVADO as synthesis tool
syn_tool = "vivado"

################################################################################
# FPGA on the RK-XCKU5P-F board
# XCKU5P-2FFVB676I according to schematic
# strange syntax with '-' needs to be used here.
syn_device = "xcku5p"
syn_grade = "-2-i"
syn_package = "-ffvb676"

# set project name and top module
syn_top = "blink_top"
syn_project = "blink"

################################################################################
# when done with bitstream generation, remove jou and log files from vivado
syn_post_bitstream_cmd = "rm -rf *.jou *.log"

syn_properties = [
    #["steps.synth_design.args.more options", "-verbose"],
    ["steps.synth_design.args.retiming", "1"],
    ["steps.synth_design.args.assert", "1"],

    ["steps.opt_design.args.verbose", "0"],
    ["steps.opt_design.args.directive", "Explore"],
    ["steps.opt_design.is_enabled", "1"],

    #["steps.place_design.args.more options", "-verbose"],
    ["steps.place_design.args.directive", "Explore"],

    #["steps.phys_opt_design.args.more options", "-verbose"],
    ["steps.phys_opt_design.args.directive", "AlternateFlowWithRetiming"],
    ["steps.phys_opt_design.is_enabled", "1"],

    #["steps.route_design.args.more options", "-verbose"],
    ["steps.route_design.args.directive", "Explore"],

    #["steps.post_route_phys_opt_design.args.more options", "-verbose"],
    ["steps.post_route_phys_opt_design.args.directive", "AddRetime"],
    ["steps.post_route_phys_opt_design.is_enabled", "1"],

    ["steps.write_bitstream.args.verbose", "0"],
    ]

################################################################################
# modules, which needed to be included
modules = {
    "local" : [
        "../../constraints",
        "../../modules/blink",
    ],
}

# local files needed for synthesis
files = [
    "blink_top.vhdl",
    ]
