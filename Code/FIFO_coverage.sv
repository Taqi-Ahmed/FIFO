package FIFO_coverage_pkg;
    import FIFO_transaction_pkg::*;

    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;

        covergroup cov_group;
            // option.per_instance = 1;
            wr_en_cp: coverpoint F_cvg_txn.wr_en;
            rd_en_cp: coverpoint F_cvg_txn.rd_en;
            wr_ack_cp: coverpoint F_cvg_txn.wr_ack;
            fullcp: coverpoint F_cvg_txn.full;
            almostfull_cp: coverpoint F_cvg_txn.almostfull;
            empty_cp: coverpoint F_cvg_txn.empty;
            almostempty_cp: coverpoint F_cvg_txn.almostempty;
            overflowcp: coverpoint F_cvg_txn.overflow;
            underflow_cp: coverpoint F_cvg_txn.underflow;

            wr_rd_en_wr_ack_cp :cross wr_en_cp,rd_en_cp,wr_ack_cp{
                illegal_bins wr_en0_rd_en0_wr_ack1 = binsof(wr_en_cp) intersect {0} &&
                                             binsof(rd_en_cp) intersect {0} &&
                                             binsof(wr_ack_cp) intersect {1} ;
                illegal_bins wr_en0_rd_en1_wr_ack1 = binsof(wr_en_cp) intersect {0} &&
                                             binsof(rd_en_cp) intersect {1} &&
                                             binsof(wr_ack_cp) intersect {1} ;
            }
            wr_rd_en_full_cp :cross wr_en_cp,rd_en_cp,fullcp{
                illegal_bins wr_en0_rd_en1_full1 = binsof(wr_en_cp) intersect {1} &&
                                             binsof(rd_en_cp) intersect {1} &&
                                             binsof(fullcp) intersect {1} ;
                illegal_bins wr_en1_rd_en1_full1 = binsof(wr_en_cp) intersect {0} &&
                                             binsof(rd_en_cp) intersect {1} &&
                                             binsof(fullcp) intersect {1} ;
            }
            wr_rd_en_empty_cp :cross wr_en_cp,rd_en_cp,empty_cp; 
            wr_rd_en_almostfull_cp :cross wr_en_cp,rd_en_cp,almostfull_cp; 
            wr_rd_en_almostempty_cp :cross wr_en_cp,rd_en_cp,almostempty_cp; 
            wr_rd_en_overflow_cp :cross wr_en_cp,rd_en_cp,overflowcp{
                illegal_bins wr_en0_rd_en0_ov1 = binsof(wr_en_cp) intersect {0} &&
                                             binsof(rd_en_cp) intersect {0} &&
                                             binsof(overflowcp) intersect {1} ;
                illegal_bins wr_en0_rd_en1_ov1 = binsof(wr_en_cp) intersect {0} &&
                                             binsof(rd_en_cp) intersect {1} &&
                                             binsof(overflowcp) intersect {1} ;
            }
            wr_rd_en_underflow_cp :cross wr_en_cp,rd_en_cp,underflow_cp{
                illegal_bins wr_en0_rd_en0_uf1 = binsof(wr_en_cp) intersect {0} &&
                                             binsof(rd_en_cp) intersect {0} &&
                                             binsof(underflow_cp) intersect {1} ;
                illegal_bins wr_en1_rd_en0_uf1 = binsof(wr_en_cp) intersect {1} &&
                                             binsof(rd_en_cp) intersect {0} &&
                                             binsof(underflow_cp) intersect {1} ;
            }

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