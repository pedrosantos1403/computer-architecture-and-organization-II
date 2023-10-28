transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3 {C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3/tomasulo.v}
vlog -vlog01compat -work work +incdir+C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3 {C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3/SomSub.v}
vlog -vlog01compat -work work +incdir+C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3 {C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3/registrador.v}
vlog -vlog01compat -work work +incdir+C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3 {C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3/FilaInstrucoes.v}
vlog -vlog01compat -work work +incdir+C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3 {C:/Users/gabri/Documents/Tomasulo-PRATICA3-CORRETO/GabrielBarbosa_GabrielLuis_pratica3/count.v}

