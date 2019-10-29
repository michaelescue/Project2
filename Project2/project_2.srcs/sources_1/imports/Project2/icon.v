// Icon module


module icon(
    input clk,              // 75Mhz clock
	input [7:0] LocX_reg,	// From rojobot
	input [7:0] LocY_reg,	// From rojobot
	input [7:0] BotInfo_reg,	// From rojobot
	input [11:0] pixel_row, 	// From DTG
	input [11:0] pixel_column,	// From DTG
	output reg [1:0] icon		// output to Colorizer
	);
	
	/**************************************** Determine Location Match ***********************************************/
	reg display;		// Combination enable when LocX or LocY equal Pixel_row and Pixel_col
	
	// Display will be determined by dividing pixel values by 8 and 6, then comparing to robot location.
	// Robot location is a single point.
		
	reg 	[11:0] 	matchedrow, matchedcol;	// Initial value of matched display location.
	reg 	[11:0] 	rowdiff, coldiff;
	wire 	[7:0]    icon_index;	// For indexing through index ROM orietations.
	wire   [6:0]   scaled_row, scaled_col;
	wire   [7:0]   douta0, douta1, douta2, douta3, 
	               douta4, douta5, douta6, douta7; 
	
	// Scaling of the map.
	scale icon_scale(	pixel_row, 
						pixel_column, 
						{scaled_row, scaled_col});
	
	assign icon_index = {rowdiff[8:5], coldiff[8:5]}; // Tied into input address of ROM
    					
	always @(posedge clk)
		begin	
			if((scaled_row == LocX_reg[6:0]) && (scaled_col == LocY_reg[6:0]))
			begin

			matchedrow = pixel_row;
			matchedcol = pixel_column;
			
				case(BotInfo_reg[2:0])
						// Each of these needs to be compared to the current pixel location and output correct icon color value.
						3'b000:    icon = douta0[1:0];	
						3'b001:    icon = douta1[1:0];
						3'b010:    icon = douta2[1:0];
						3'b011:    icon = douta3[1:0];
						3'b100:    icon = douta4[1:0];
						3'b101:    icon = douta5[1:0];
						3'b110:    icon = douta6[1:0];
						3'b111:    icon = douta7[1:0];
			     endcase
		    end
            else
                icon = 0;
		    end
			 rowdiff = pixel_row - matchedrow;
             coldiff = pixel_column - matchedcol;
   end	
   
   	blk_mem_gen_0 orientation0 (
     .clka(clk),    // input wire clka
     .ena(1),      // input wire ena
     .addra(icon_index),  // input wire [7 : 0] addra
     .douta(douta0)  // output wire [7 : 0] douta
   );
   
   blk_mem_gen_1 orientation45 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta1)  // output wire [7 : 0] douta
   );
   
   blk_mem_gen_2 orientation90 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta2)  // output wire [7 : 0] douta
   );
   
   blk_mem_gen_3 orientation135 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta3)  // output wire [7 : 0] douta
   );
   
   blk_mem_gen_4 orientation180 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta4)  // output wire [7 : 0] douta
   );
   
   blk_mem_gen_5 orientation225 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta5)  // output wire [7 : 0] douta
   );
   
   blk_mem_gen_6 orientation270 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta6)  // output wire [7 : 0] douta
   );
       
   blk_mem_gen_7 orientation315 (
       .clka(clk),    // input wire clka
       .ena(1),      // input wire ena
       .addra(icon_index),  // input wire [7 : 0] addra
       .douta(douta7)  // output wire [7 : 0] douta
   );
   	
endmodule