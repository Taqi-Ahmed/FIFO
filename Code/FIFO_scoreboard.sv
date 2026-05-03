package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*;
    import shared_pkg::*;
    class FIFO_scoreboard ;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        
        integer counter =0;
        integer rd_ptr = 0;
        integer wr_ptr = 0;
        logic [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];

        task check_data(FIFO_transaction f_txn);
            ref_model(f_txn);
            if(data_out_ref != f_txn.data_out)begin
                $display("ERROR: data_out incorrect, data_in=%0h, rd_en=%0h, wr_en=%0h, dut_data_out=%0h, ref_data_out = %0h", 
                            f_txn.data_in, f_txn.rd_en, f_txn.wr_en,f_txn.data_out,data_out_ref);
                error_count++;
            end
            else begin
                correct_count++;
            end
        endtask

        task ref_model(FIFO_transaction f_txn);
            if(!f_txn.rst_n) begin
                empty_ref = 1;
                full_ref =0;
                almostempty_ref = 0;
                almostfull_ref = 0;
                data_out_ref = 0;
                wr_ack_ref = 0; 
                overflow_ref = 0;
                underflow_ref = 0;

                counter =0;
                rd_ptr = 0;
                wr_ptr = 0;
            end

            else begin
                
                if(f_txn.rd_en && f_txn.wr_en) begin
                    if(counter == 0) begin //allow write only
                        mem_ref[wr_ptr] = f_txn.data_in;
                        wr_ack_ref = 1;
                        counter++;
                        wr_ptr = (wr_ptr +1) % FIFO_DEPTH;
                    end
                    else if(counter == FIFO_DEPTH) begin //allow read only
                        data_out_ref = mem_ref[rd_ptr];
                        counter--;
                        rd_ptr = (rd_ptr +1) % FIFO_DEPTH;
                        wr_ack_ref = 0;
                    end
                    else begin //one read and one write
                        mem_ref[wr_ptr] = f_txn.data_in;
                        wr_ack_ref = 1;
                        wr_ptr = (wr_ptr +1) % FIFO_DEPTH;
                        data_out_ref = mem_ref[rd_ptr];
                        rd_ptr = (rd_ptr +1) % FIFO_DEPTH;
                    end
                end
                else if(f_txn.rd_en)begin //read
                    if(counter != 0)begin
                        data_out_ref = mem_ref[rd_ptr];
                        counter--;
                        rd_ptr = (rd_ptr +1) % FIFO_DEPTH;
                        wr_ack_ref = 0;
                    end 
                end
                else if(f_txn.wr_en)begin //write
                    if(counter != FIFO_DEPTH)begin
                        mem_ref[wr_ptr] = f_txn.data_in;
                        wr_ack_ref = 1;
                        counter++;
                        wr_ptr = (wr_ptr +1) % FIFO_DEPTH;
                    end 
                end
                
                empty_ref = (counter == 0)? 1:0;
                almostempty_ref = (counter == 1)? 1:0;
                full_ref = (counter == FIFO_DEPTH)? 1:0;
                almostfull_ref = (counter == FIFO_DEPTH -1)? 1:0;
            end
        endtask
        
    endclass
endpackage
