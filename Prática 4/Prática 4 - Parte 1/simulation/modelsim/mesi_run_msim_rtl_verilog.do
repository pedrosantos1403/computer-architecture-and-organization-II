transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/LaboratÃ³rio\ AOC\ II/PrÃ¡ticas\ AOC2/PrÃ¡tica\ 4/PrÃ¡tica\ 4\ -\ Parte\ 1 {C:/Users/pedro/OneDrive/Documentos/CEFETMG/2023.2/Laboratório AOC II/Práticas AOC2/Prática 4/Prática 4 - Parte 1/mesi.v}

