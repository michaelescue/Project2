module scale(
	input [11:0] pixel_row,
	input [11:0] pixel_column,
	output [13:0] vid_addr);
	
	wire [6:0] scaled_row, scaled_col;
	
	assign scaled_row = pixel_row/6;
	assign scaled_col = pixel_column/8;
	
	assign vid_addr = {scaled_row, scaled_col};

endmodule