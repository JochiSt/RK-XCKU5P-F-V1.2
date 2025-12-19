action = "simulation"

sim_tool = "ghdl"
sim_top = "tb_blink"
ghdl_opt = "--workdir=work -fsynopsys --std=93c"

sim_post_cmd = "ghdl -r tb_blink --stop-time=5ms --wave=tb_blink.ghw"

incl_makefiles = [
    "../../MakeView.mk",
    ]

modules = {
    "local" : [
        "../../../modules/blink/",
    ],
}

files = [
    "tb_blink.vhdl",
    ]