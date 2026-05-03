onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/clk
add wave -noupdate -group Interface /top/fifoif/FIFO_WIDTH
add wave -noupdate -group Interface /top/fifoif/FIFO_DEPTH
add wave -noupdate -group Interface /top/fifoif/clk
add wave -noupdate -group Interface /top/fifoif/data_in
add wave -noupdate -group Interface /top/fifoif/rst_n
add wave -noupdate -group Interface /top/fifoif/wr_en
add wave -noupdate -group Interface /top/fifoif/rd_en
add wave -noupdate -group Interface /top/fifoif/data_out
add wave -noupdate -group Interface /top/fifoif/wr_ack
add wave -noupdate -group Interface /top/fifoif/full
add wave -noupdate -group Interface /top/fifoif/empty
add wave -noupdate -group Interface /top/fifoif/almostfull
add wave -noupdate -group Interface /top/fifoif/almostempty
add wave -noupdate -group Interface /top/fifoif/underflow
add wave -noupdate -group Interface /top/fifoif/overflow
add wave -noupdate -group Interface /top/fifoif/ev_trig
add wave -noupdate -expand -group {Coverage signals} /top/monitor/f_cov
add wave -noupdate -expand -group {Monitor txn} /top/monitor/f_txn_mon
add wave -noupdate -expand -group Scoreboard /top/monitor/f_sb
add wave -noupdate -group ASSERTIONS /top/DUT/wr_ack_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/overflow_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/underflow_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/empty_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/full_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/almost_full_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/almost_empty_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/wr_ptr_wraparound_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/rd_ptr_wraparound_asrt
add wave -noupdate -group ASSERTIONS /top/DUT/ptr_threshold_asrt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {57 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
