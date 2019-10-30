module counter_column(
	input clk,
	input reset,
	input clear,
	input enable,
	output reg [7:0] count_column);
	
always@(posedge clk) begin

	if(reset)		count_column <= 0;
	else if(clear)	count_column <= 0;
	else if(enable) count_column <= count_column + 1; 
	else 			count_column <= count_column;
	
end

endmodule