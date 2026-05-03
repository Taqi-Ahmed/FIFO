module top;
    bit clk;
    
    initial begin
        clk = 0;
        forever begin
             #1 clk = ~clk;
        end
    end

    FIFO_if fifoif(clk);
    
    always_comb begin
        if(!fifoif.rst_n) begin
            assert final (
                            fifoif.empty&&
                            !fifoif.full&&
                            !fifoif.almostempty &&
                            !fifoif.almostfull &&
                            !fifoif.wr_ack &&
                            !fifoif.overflow &&
                            !fifoif.underflow &&
                            fifoif.data_out == '0
                        );
        end
    end

    FIFO DUT(fifoif);
    FIFO_monitor monitor(fifoif);
    tb test(fifoif);

endmodule