module counter_row(
	input clk,
	input reset,
	input clear,
	input enable,
	output reg [7:0] count_row);
	
always@(posedge clk) begin

	if(reset)		count_row <= 0;
	else if(clear)	count_row <= 0;
	else if(enable) count_row <= count_row +1; 
	else 			count_row <= count_row;
	
end

endmodule