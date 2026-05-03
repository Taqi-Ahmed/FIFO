vlib work
vlog FIFO_if.sv FIFO.sv shared_pkg.sv FIFO_transaction.sv FIFO_coverage.sv FIFO_scoreboard.sv FIFO_monitor.sv tb.sv top.sv  +cover 
vsim -voptargs=+acc work.top -cover
add wave *
coverage save top.ucdb  -onexit
run 0
add wave -position end  sim:/top/monitor/f_cov
add wave -position end  sim:/top/monitor/f_txn_mon
add wave -position end  sim:/top/monitor/f_sb
run -all