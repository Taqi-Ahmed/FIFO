    import FIFO_transaction_pkg::*;
    import FIFO_scoreboard_pkg::*;
    import FIFO_coverage_pkg::*;
    import shared_pkg::*;

    module FIFO_monitor(FIFO_if.MONITOR fifoif);
        FIFO_coverage f_cov;
        FIFO_transaction f_txn_mon;
        FIFO_scoreboard f_sb;
        initial begin
            f_cov = new();
            f_txn_mon = new;
            f_sb = new();

            forever begin
                wait(fifoif.ev_trig.triggered);
                @(negedge fifoif.clk);
                //wait for test to trigger event 
                //wait(fifoif.ev_trig.triggered);
                //sample signals from interface into the transaction object
                f_txn_mon.rst_n = fifoif.rst_n;
                f_txn_mon.rd_en = fifoif.rd_en;
                f_txn_mon.wr_en = fifoif.wr_en;
                f_txn_mon.data_in = fifoif.data_in;
                f_txn_mon.data_out = fifoif.data_out;
                f_txn_mon.wr_ack = fifoif.wr_ack;
                f_txn_mon.full = fifoif.full;
                f_txn_mon.empty = fifoif.empty;
                f_txn_mon.almostempty = fifoif.almostempty;
                f_txn_mon.almostfull = fifoif.almostfull;
                f_txn_mon.overflow = fifoif.overflow;
                f_txn_mon.underflow = fifoif.underflow;
                
                //forking to run coverage and scoreboard in parallel
                fork
                    begin
                        f_cov.sample_data(f_txn_mon);
                    end
                    
                    begin
                        f_sb.check_data(f_txn_mon);
                    end
                join

                ->fifoif.ev_monitor_finish;
                //check if test finished then stop simulation
                if(test_finished) begin
                    $display("TEST FINISHED: Correct Count = %0d, Error Count = %0d", correct_count,error_count);
                    $stop;
                end
            end
        end
    endmodule
