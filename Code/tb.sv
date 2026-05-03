import shared_pkg::*;
import FIFO_transaction_pkg::*;

module tb(FIFO_if.TEST fifoif);

    FIFO_transaction f_txn_tb;

    initial begin
        f_txn_tb = new();
        test_finished = 0;

        fifoif.rst_n = 0;
        ->fifoif.ev_trig;
        @(negedge fifoif.clk);
        fifoif.rst_n = 1;

        repeat(10)begin
            assert(f_txn_tb.randomize());
            fifoif.rd_en = f_txn_tb.rd_en;
            fifoif.wr_en = f_txn_tb.wr_en;
            fifoif.data_in = f_txn_tb.data_in;
            fifoif.rst_n = f_txn_tb.rst_n;
            @(negedge fifoif.clk);
            -> fifoif.ev_trig;
        end
        test_finished = 1;
        
    end


    
endmodule