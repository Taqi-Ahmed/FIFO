module top;
    bit clk;
    initial begin
        clk = 0;
        forever begin
             clk = ~clk;
        end
    end

    FIFO DUT(fifo_if)
endmodule