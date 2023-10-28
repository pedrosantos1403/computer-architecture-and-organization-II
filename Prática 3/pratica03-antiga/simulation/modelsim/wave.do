onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tomasulo/clk
add wave -noupdate /tomasulo/i
add wave -noupdate /tomasulo/Tempo
add wave -noupdate /tomasulo/breakLoop
add wave -noupdate /tomasulo/minTempo
add wave -noupdate /tomasulo/primeiraIntrucao
add wave -noupdate -radix decimal /tomasulo/registrador0
add wave -noupdate -radix decimal /tomasulo/registrador1
add wave -noupdate -radix decimal /tomasulo/registrador2
add wave -noupdate -radix decimal /tomasulo/registrador3
add wave -noupdate -radix decimal /tomasulo/registrador4
add wave -noupdate -radix decimal /tomasulo/registrador5
add wave -noupdate /tomasulo/instrucao
add wave -noupdate /tomasulo/inZ
add wave -noupdate /tomasulo/inX
add wave -noupdate /tomasulo/inY
add wave -noupdate /tomasulo/inI
add wave -noupdate /tomasulo/controleSomSub
add wave -noupdate /tomasulo/doneSomSub
add wave -noupdate /tomasulo/RUNSomSub
add wave -noupdate /tomasulo/opSomSub
add wave -noupdate /tomasulo/inX_SomSub
add wave -noupdate /tomasulo/InLabelSomSub
add wave -noupdate /tomasulo/enderecoX
add wave -noupdate /tomasulo/labelSomSub
add wave -noupdate /tomasulo/regX
add wave -noupdate /tomasulo/regY
add wave -noupdate /tomasulo/regZ
add wave -noupdate /tomasulo/resultadoSomSub
add wave -noupdate /tomasulo/rotuloEstacao
add wave -noupdate /tomasulo/Regs
add wave -noupdate /tomasulo/newLabel
add wave -noupdate /tomasulo/newData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 233
configure wave -valuecolwidth 193
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
WaveRestoreZoom {850 ps} {1686 ps}
