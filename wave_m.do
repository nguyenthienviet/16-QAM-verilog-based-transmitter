onerror {resume}
radix fpoint 3
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_M/top/md/clk
add wave -noupdate /tb_M/top/md/parallel_data
add wave -noupdate -color Red /tb_M/top/md/I
add wave -noupdate -color Red /tb_M/top/md/I_4level
add wave -noupdate -color Red -format Analog-Step -height 74 -max 98301.0 -min -98301.0 -radix decimal /tb_M/top/md/I_com
add wave -noupdate -color Blue /tb_M/top/md/Q
add wave -noupdate -color Blue /tb_M/top/md/Q_4level
add wave -noupdate -color Blue -format Analog-Step -height 74 -max 98301.0 -min -98301.0 -radix decimal /tb_M/top/md/Q_com
add wave -noupdate -color Green -format Analog-Step -height 74 -max 138591.0 -min -138591.0 -radix decimal /tb_M/top/md/mixed_output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {657288 ns} 0} {{Cursor 2} {136425 ns} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ns} {735 us}
