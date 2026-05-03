////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT fifoif);

 
localparam max_fifo_addr = $clog2(fifoif.FIFO_DEPTH);

reg [fifoif.FIFO_WIDTH-1:0] mem [fifoif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		wr_ptr <= 0;			
		fifoif.wr_ack <= 0;		//BUG: reset wr_ack was missing
		fifoif.overflow <= 0; 	//BUG: reset for overflow was missing
	end
	else if (fifoif.wr_en && count < fifoif.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifoif.data_in;
		fifoif.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		fifoif.overflow <= 0;  //BUG: should pull overflow back to 0 if we wrote normally
	end
	else begin 
		fifoif.wr_ack <= 0; 
		if (fifoif.full & fifoif.wr_en)
			fifoif.overflow <= 1;
		else
			fifoif.overflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		rd_ptr <= 0;
		fifoif.data_out <= 0; //BUG: reset for dataout was missing	
		fifoif.underflow <= 0; //BUG: reset for underflow was missing	
	end
	else if (fifoif.rd_en && count != 0) begin
		fifoif.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		fifoif.underflow<= 0; //BUG: should pull underflow back to 0 if we read normally
	end
	else begin  //BUG: handling of underflow was missing
		if (fifoif.empty & fifoif.rd_en)
			fifoif.underflow <= 1;
		else
			fifoif.underflow <= 0;
	end
end

always @(posedge fifoif.clk or negedge fifoif.rst_n) begin
	if (!fifoif.rst_n) begin
		count <= 0;
		
	end
	else begin
		if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b10) && !fifoif.full) 
			count <= count + 1;
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b01) && !fifoif.empty)
			count <= count - 1;
		//BUG: should check when both are high and increment counter if empty
		else if	( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.empty) 
			count <= count + 1;
		//BUG: should check when both are high and decrement counter based if full
		else if ( ({fifoif.wr_en, fifoif.rd_en} == 2'b11) && fifoif.full)
			count <= count - 1;
	end
end

assign fifoif.full = (count == fifoif.FIFO_DEPTH)? 1 : 0;
assign fifoif.empty = (count == 0)? 1 : 0;
//assign fifoif.underflow = (fifoif.empty && fifoif.rd_en)? 1 : 0; //BUG: underflow should be driven as a sequential signal
assign fifoif.almostfull = (count == fifoif.FIFO_DEPTH-1)? 1 : 0; //BUG: was written as fifodepth -2 instead of 1
assign fifoif.almostempty = (count == 1)? 1 : 0;

//=================== ASSERTIONS ===========================
	always_comb begin
		if(!fifoif.rst_n) begin
			assert final( (wr_ptr == 'b0) && (rd_ptr == 'b0)
							&& (count == 'b0));
		end
	end

	property wr_ack_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (fifoif.wr_en && !fifoif.full) |=> fifoif.wr_ack ;
	endproperty
	property overflow_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (fifoif.wr_en && fifoif.full) |=> fifoif.overflow ;
	endproperty
	property underflow_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (fifoif.rd_en && fifoif.empty) |=> fifoif.underflow ;
	endproperty
	property empty_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (count == 'b0) |-> fifoif.empty;
	endproperty
	property full_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (count == fifoif.FIFO_DEPTH) |-> fifoif.full;
	endproperty
	property almost_full_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (count == fifoif.FIFO_DEPTH -1) |-> fifoif.almostfull;
	endproperty
	property almost_empty_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (count == 1) |-> fifoif.almostempty;
	endproperty
	property wr_ptr_wraparound_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) ((wr_ptr == fifoif.FIFO_DEPTH-1) && fifoif.wr_en && !fifoif.full) |=> wr_ptr ==0 ;
	endproperty
	property ptr_threshold_pr;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) ((rd_ptr < fifoif.FIFO_DEPTH) && (wr_ptr<fifoif.FIFO_DEPTH) && (count<=fifoif.FIFO_DEPTH));
	endproperty

	wr_ack_asrt: assert property (wr_ack_pr)
		else $error("Assertion wr_ack_asrt failed!");
	overflow_asrt: assert property (overflow_pr)
		else $error("Assertion overflow_asrt failed!");
	underflow_asrt: assert property (underflow_pr)
		else $error("Assertion underflow_asrt failed!");
	empty_asrt: assert property (empty_pr)
		else $error("Assertion empty_asrt failed!");
	full_asrt: assert property (full_pr)
		else $error("Assertion full_asrt failed!");
	almost_full_asrt: assert property (almost_full_pr)
		else $error("Assertion almost_full_asrt failed!");
	almost_empty_asrt: assert property (almost_empty_pr)
		else $error("Assertion almost_empty_asrt failed!");
	wr_ptr_wraparound_asrt: assert property (wr_ptr_wraparound_pr)
		else $error("Assertion wr_ptr_wraparound_asrt failed!");
	ptr_threshold_asrt: assert property (ptr_threshold_pr)
		else $error("Assertion ptr_threshold_asrt failed!");

	wr_ack_cov: cover property (wr_ack_pr);
	overflow_cov: cover property (overflow_pr);
	underflow_cov: cover property (underflow_pr);
	empty_cov: cover property (empty_pr);
	full_cov: cover property (full_pr);
	almost_full_cov: cover property (almost_full_pr);
	almost_empty_cov: cover property (almost_empty_pr);
	wr_ptr_wraparound_cov: cover property (wr_ptr_wraparound_pr);
	ptr_threshold_cov: cover property (ptr_threshold_pr);

endmodule