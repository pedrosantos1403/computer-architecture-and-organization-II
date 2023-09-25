transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/processador.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/regn_pc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/regn.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/Mux10to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/dec3to8.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/ALUn.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/upcount.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/ram_lpm.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/rom_lpm.v}
vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat贸rio\ AOC\ II/Pr谩tica\ 2\ -\ Rodrigo/pratica_2 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2022.2/Laborat髍io AOC II/Pr醫ica 2 - Rodrigo/pratica_2/pratica_2.v}

