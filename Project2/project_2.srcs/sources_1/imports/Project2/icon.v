// Icon module


module icon(
	input [7:0] LocX_reg,	// From rojobot
	input [7:0] LocY_reg,	// From rojobot
	input [7:0] BotInfo_reg,	// From rojobot
	input [11:0] pixel_row, 	// From DTG
	input [11:0] pixel_column,	// From DTG
	output reg icon		// output to Colorizer
	);
	
	/**************************************** Determine Location Match ***********************************************/
	reg display;		// Combination enable when LocX or LocY equal Pixel_row and Pixel_col
	
	// Display will be determined by dividing pixel values by 8 and 6, then comparing to robot location.
	// Robot location is a single point.
		
	reg 	[11:0] 	matchedrow, matchedcol;	// Initial value of matched display location.
	wire 	[6:0] 	rowdiff, coldiff;
	wire 	[7:0] 	icon_index;	// For indexing through index ROM orietations.
	reg 	[8:0] 	output_matrix;
	wire   [6:0] scaled_row, scaled_col;
	
	scale icon_scale(	pixel_row, 
						pixel_column, 
						{scaled_row, scaled_col});
	
	assign rowdiff = (pixel_row - matchedrow);
	assign coldiff = (pixel_column - matchedcol);

	assign icon_index = {coldiff[4:1], rowdiff[4:1]}; // Tied into input address of ROM
						
	
	always @(*)
		begin	
			if((scaled_row == LocX_reg[6:0]) && (scaled_col == LocY_reg[6:0]))
			begin

			matchedrow = pixel_row;
			matchedcol = pixel_column;
			
				case(BotInfo_reg[2:0])
						// Each of these needs to be compared to the current pixel location and output correct icon color value.
						0:    output_matrix = douta0;	
						1:    output_matrix = douta1;
						2:    output_matrix = douta2;
						3:    output_matrix = douta3;
						4:    output_matrix = douta4;
						5:    output_matrix = douta5;
						6:    output_matrix = douta6;
						7:    output_matrix = douta7;
			     endcase
		      end
		    end
				
endmodule