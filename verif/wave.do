onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_comp_mult/clk
add wave -noupdate /tb_comp_mult/rst_n
add wave -noupdate -divider inputs
add wave -noupdate -radix decimal /tb_comp_mult/a
add wave -noupdate -radix decimal /tb_comp_mult/b
add wave -noupdate -radix decimal /tb_comp_mult/c
add wave -noupdate -radix decimal /tb_comp_mult/d
add wave -noupdate -divider W
add wave -noupdate -radix decimal /tb_comp_mult/sim_w
add wave -noupdate -radix decimal /tb_comp_mult/w
add wave -noupdate -divider X
add wave -noupdate -radix decimal /tb_comp_mult/sim_x
add wave -noupdate -radix decimal /tb_comp_mult/x
add wave -noupdate -divider Y
add wave -noupdate -radix decimal /tb_comp_mult/sim_y
add wave -noupdate -radix decimal /tb_comp_mult/y
add wave -noupdate -divider Z
add wave -noupdate -radix decimal /tb_comp_mult/sim_z
add wave -noupdate -radix decimal /tb_comp_mult/z
add wave -noupdate -divider Valid
add wave -noupdate /tb_comp_mult/i_valid
add wave -noupdate /tb_comp_mult/o_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {15 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {205 ps}
