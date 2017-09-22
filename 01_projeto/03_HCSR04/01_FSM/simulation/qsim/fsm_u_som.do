onerror {exit -code 1}
vlib work
vcom -work work fsm_u_som.vho
vcom -work work Waveform1.vwf.vht
vsim -novopt -c -t 1ps -sdfmax fsm_u_som_vhd_vec_tst/i1=fsm_u_som_vhd.sdo -L cycloneive -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.fsm_u_som_vhd_vec_tst
vcd file -direction fsm_u_som.msim.vcd
vcd add -internal fsm_u_som_vhd_vec_tst/*
vcd add -internal fsm_u_som_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
