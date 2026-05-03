package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;

    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;

        covergroup cov_group;
            wr_en_cp: coverpoint F_cvg_txn.wr_en{
                option.weight = 0;
            }
            rd_en_cp: coverpoint F_cvg_txn.rd_en{
                option.weight = 0;
            }
            wr_ack_cp: coverpoint F_cvg_txn.wr_ack{
                option.weight = 0;
            }
            fullcp: coverpoint F_cvg_txn.full{
                option.weight = 0;
            }
            almostfull_cp: coverpoint F_cvg_txn.almostfull{
                option.weight = 0;
            }
            empty_cp: coverpoint F_cvg_txn.empty{
                option.weight = 0;
            }
            almostempty_cp: coverpoint F_cvg_txn.almostempty{
                option.weight = 0;
            }
            overflowcp: coverpoint F_cvg_txn.overflow{
                option.weight = 0;
            }
            underflow_cp: coverpoint F_cvg_txn.underflow{
                option.weight = 0;
            }

            wr_rd_en_wr_ack_cp :cross wr_en_cp,rd_en_cp,wr_ack_cp;
            wr_rd_en_full_cp :cross wr_en_cp,rd_en_cp,fullcp; 
            wr_rd_en_empty_cp :cross wr_en_cp,rd_en_cp,empty_cp; 
            wr_rd_en_almostfull_cp :cross wr_en_cp,rd_en_cp,almostfull_cp; 
            wr_rd_en_almostempty_cp :cross wr_en_cp,rd_en_cp,almostempty_cp; 
            wr_rd_en_overflow_cp :cross wr_en_cp,rd_en_cp,overflowcp; 
            wr_rd_en_underflow_cp :cross wr_en_cp,rd_en_cp,underflow_cp; 

        endgroup

        function new();
            cov_group = new();
        endfunction //new()

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            cov_group.sample();
        endfunction

    endclass //FIFO_coverage

endpackage