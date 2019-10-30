// Icon module


module icon(
    input clk,              // 75Mhz clock
    input reset,
	input [7:0] LocX_reg,	// From rojobot
	input [7:0] LocY_reg,	// From rojobot
	input [7:0] BotInfo_reg,	// From rojobot
	input [11:0] pixel_row, 	// From DTG
	input [11:0] pixel_column,	// From DTG
	output reg [1:0] icon		// output to Colorizer
	);
	
	/**************************************** Determine Location Match ***********************************************/
	
	// Display will be determined by dividing pixel values by 8 and 6, then comparing to robot location.
	// Robot location is a single point.
		
	reg 	[11:0] 	matchedrow, matchedcol;	// Initial value of matched display location.
	reg 	[7:0]    icon_index;	// For indexing through index ROM orietations.
	wire   [6:0]   scaled_row, scaled_col;
	wire   [7:0]   douta0, douta1, douta2, douta3, 
	               douta4, douta5, douta6, douta7;
	               

	reg [11:0] count_row, count_column;
	reg start_count;
	reg [11:0] limit_count;
	reg icon_on;
	
parameter
            HORIZ_PIXELS = 1024,  
            HCNT_MAX  = 1327,         
            HSYNC_START  = 1053,  
            HSYNC_END = 1189,
            
            HORIZ_SIZE = 32,
            VERT_SIZE = 32,
    
            VERT_PIXELS  = 768,  
            VCNT_MAX  = 805,
            VSYNC_START  = 773,  
            VSYNC_END = 779;
            
    reg [11:0]vert_pix_max, vert_pix_min, horiz_pix_max, horiz_pix_min;          
	               	
	// Scaling of the map.
	scale icon_scale(	pixel_row, 
						pixel_column, 
						{scaled_row, scaled_col});

always @(posedge clk) begin
	if (reset) begin
		count_column <= 0;
		count_row    <= 0;
		icon_on     <= 0;
	end
	else begin
		// increment horizontal sync counter.  Wrap if at end of row
		if (count_column == HCNT_MAX)	
			count_column <= 12'd0;
		else	
			count_column <= count_column + 12'd1;
			
		// increment vertical sync ounter.  Wrap if at end of display.  Increment if end of row
		if ((pixel_row >= VCNT_MAX) && (count_column >= HCNT_MAX))
			count_row <= 12'd0;
		else if (count_column == HCNT_MAX)
			count_row <= count_row + 12'd1;
									
		// generate the video_on signals and the pixel counts
		icon_on <= ((count_column < horiz_pix_max) && (count_row < vert_pix_max)&&(count_column > horiz_pix_min) && (count_row > vert_pix_min));
	end
end

    always @(*)
        begin
            if((scaled_row == LocY_reg[6:0]) && (scaled_col == LocX_reg[6:0])) begin
               matchedrow = pixel_row; 
               matchedcol = pixel_column;
               horiz_pix_min = matchedcol;
               horiz_pix_max = horiz_pix_min + HORIZ_SIZE;
               vert_pix_min = matchedrow;
               vert_pix_max = vert_pix_min + VERT_SIZE;
            end
        end
	
	always@(*)
        begin
            icon_index = {count_row[3:0], count_column[3:0]};
            
            if(icon_on) begin
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
                icon = 2'b0;
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