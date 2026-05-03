interface FIFO_if(clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
    input clk;

    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;

    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack,full, empty, almostfull, almostempty, underflow, overflow;

    event ev_trig;

    modport DUT (
    input data_in,clk,rst_n, wr_en, rd_en,
    output data_out,wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );

    modport MONITOR (
    input ev_trig,data_in,clk,rst_n, wr_en, rd_en,data_out,wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );

    modport TEST (
    input clk,data_out,wr_ack, overflow, full, empty, almostfull, almostempty, underflow,
    output ev_trig,data_in,rst_n, wr_en,rd_en
    );

endinterface