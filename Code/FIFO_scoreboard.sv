package FIFO_scoreboard_pkg;
    import FIFO_transaction_pkg::*;
    import shared_pkg::*;
    class FIFO_scoreboard ;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        
        logic [FIFO_WIDTH-1:0] myQueue[$];

        task check_data(FIFO_transaction f_txn);
            ref_model(f_txn);
            if(data_out_ref !== f_txn.data_out)begin
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

                myQueue.delete();
            end

            else begin
                
                if(f_txn.rd_en && f_txn.wr_en) begin
                    if(myQueue.size() == 0) begin //allow write only
                        myQueue.push_back(f_txn.data_in);
                        wr_ack_ref = 1;
                                    
                    end
                    else if(myQueue.size() == FIFO_DEPTH) begin //allow read only
                        data_out_ref = myQueue.pop_front();                      
                        wr_ack_ref = 0;
                    end
                    else begin //one read and one write
                        myQueue.push_back(f_txn.data_in);
                        wr_ack_ref = 1;
                        data_out_ref = myQueue.pop_front();
                        
                    end
                end
                else if(f_txn.rd_en)begin //read
                    if(myQueue.size() != 0)begin
                        data_out_ref = myQueue.pop_front();    
                        wr_ack_ref = 0;
                    end 
                end
                else if(f_txn.wr_en)begin //write
                    if(myQueue.size() != FIFO_DEPTH)begin
                        myQueue.push_back(f_txn.data_in);
                        wr_ack_ref = 1;                
                    end 
                end
                
                empty_ref = (myQueue.size() == 0)? 1:0;
                almostempty_ref = (myQueue.size() == 1)? 1:0;
                full_ref = (myQueue.size() == FIFO_DEPTH)? 1:0;
                almostfull_ref = (myQueue.size() == FIFO_DEPTH -1)? 1:0;
            end
        endtask
        
    endclass
endpackage
