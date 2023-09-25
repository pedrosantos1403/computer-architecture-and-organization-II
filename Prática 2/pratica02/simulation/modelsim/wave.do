onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pratica2/PClock
add wave -noupdate /pratica2/ResetIn
add wave -noupdate /pratica2/Run
add wave -noupdate /pratica2/bus
add wave -noupdate -radix decimal /pratica2/Reg0
add wave -noupdate -radix decimal /pratica2/Reg1
add wave -noupdate -radix decimal /pratica2/Reg2
add wave -noupdate -radix decimal /pratica2/Reg3
add wave -noupdate -radix decimal /pratica2/Reg4
add wave -noupdate /pratica2/Reg5
add wave -noupdate /pratica2/Reg6
add wave -noupdate /pratica2/Reg7
add wave -noupdate /pratica2/done
add wave -noupdate /pratica2/index
add wave -noupdate /pratica2/DIN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4838 ps} 0}
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
WaveRestoreZoom {4350 ps} {5350 ps}
