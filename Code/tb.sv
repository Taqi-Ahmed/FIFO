import shared_pkg::*;
import FIFO_transaction_pkg::*;

module tb(FIFO_if.TEST fifoif);

    FIFO_transaction f_txn_tb;

    initial begin
        f_txn_tb = new();
        test_finished = 0;

        //====TESET RESET==============================================//
        fifoif.rst_n = 0;
        ->fifoif.ev_trig;
        repeat(10) @(negedge fifoif.clk);
        fifoif.rst_n = 1;
        //====TESET WRITE CONSECUTIVE ==============================================//
        repeat(100)begin
            assert(f_txn_tb.randomize());
            fifoif.rd_en = 0;
            fifoif.wr_en = 1;
            fifoif.data_in = f_txn_tb.data_in;
            fifoif.rst_n = 1;
            -> fifoif.ev_trig;
            @(negedge fifoif.clk);
        end
        //====TESET READ CONSECUTIVE ==============================================//
        repeat(100)begin
            assert(f_txn_tb.randomize());
            fifoif.rd_en = 1;
            fifoif.wr_en = 0;
            fifoif.data_in = f_txn_tb.data_in;
            fifoif.rst_n = 1;
            -> fifoif.ev_trig;
            @(negedge fifoif.clk);
        end
        //====TESET READ and WRITE CONSECUTIVE ==============================================//
        repeat(100)begin
            assert(f_txn_tb.randomize());
            fifoif.rd_en = 1;
            fifoif.wr_en = 1;
            fifoif.data_in = f_txn_tb.data_in;
            fifoif.rst_n = 1;
            -> fifoif.ev_trig;
            @(negedge fifoif.clk);
        end
        //====TESET RANDOMIZED==============================================//
        repeat(10000)begin
            assert(f_txn_tb.randomize());
            fifoif.rd_en = f_txn_tb.rd_en;
            fifoif.wr_en = f_txn_tb.wr_en;
            fifoif.data_in = f_txn_tb.data_in;
            fifoif.rst_n = f_txn_tb.rst_n;
            -> fifoif.ev_trig;
            @(negedge fifoif.clk);         
        end        
        //====TESET FINISHED==============================================//

        test_finished = 1;
        -> fifoif.ev_trig;
        @(negedge fifoif.clk);
        
    end


    
endmodule