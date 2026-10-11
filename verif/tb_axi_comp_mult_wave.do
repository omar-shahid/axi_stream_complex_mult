onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_axi_comp_mult/clk
add wave -noupdate /tb_axi_comp_mult/rst_n
add wave -noupdate -divider AXI
add wave -noupdate /tb_axi_comp_mult/TVALID
add wave -noupdate /tb_axi_comp_mult/TREADY
add wave -noupdate /tb_axi_comp_mult/TDATA
add wave -noupdate /tb_axi_comp_mult/TLAST
add wave -noupdate -divider a
add wave -noupdate -radix decimal /tb_axi_comp_mult/a
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/a
add wave -noupdate -divider b
add wave -noupdate -radix decimal /tb_axi_comp_mult/b
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/b
add wave -noupdate -divider c
add wave -noupdate -radix decimal /tb_axi_comp_mult/c
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/c
add wave -noupdate -divider d
add wave -noupdate -radix decimal /tb_axi_comp_mult/d
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/d
add wave -noupdate -divider W
add wave -noupdate -radix decimal /tb_axi_comp_mult/sim_w
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/w
add wave -noupdate -divider X
add wave -noupdate -radix decimal /tb_axi_comp_mult/sim_x
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/x
add wave -noupdate -divider Y
add wave -noupdate -radix decimal /tb_axi_comp_mult/sim_y
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/y
add wave -noupdate -divider Z
add wave -noupdate -radix decimal /tb_axi_comp_mult/sim_z
add wave -noupdate -radix decimal /tb_axi_comp_mult/dut/z
add wave -noupdate -divider Valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {34 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {183 ps}
