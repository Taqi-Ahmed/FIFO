module tb;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic [FIFO_WIDTH-1:0] data_in;
    logic clk, rst_n, wr_en, rd_en;
    logic  [FIFO_WIDTH-1:0] data_out;
    logic  wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    //Instantiate the DUT
    FIFO #(FIFO_WIDTH,FIFO_WIDTH) DUT(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .wr_ack(wr_ack),
        .overflow(overflow),
        .underflow(underflow)
        .full(full),
        .empty(empty),
        .almostfull(almostfull),
        .almostempty(almostempty)  
    );


    
endmodule