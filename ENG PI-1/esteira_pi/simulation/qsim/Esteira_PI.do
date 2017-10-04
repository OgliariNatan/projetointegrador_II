onerror {quit -f}
vlib work
vlog -work work Esteira_PI.vo
vlog -work work Esteira_PI.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Esteira_PI_vlg_vec_tst
vcd file -direction Esteira_PI.msim.vcd
vcd add -internal Esteira_PI_vlg_vec_tst/*
vcd add -internal Esteira_PI_vlg_vec_tst/i1/*
add wave /*
run -all
