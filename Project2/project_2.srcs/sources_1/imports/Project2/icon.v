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
	//reg display;		// Combination enable when LocX or LocY equal Pixel_row and Pixel_col
	
	// Display will be determined by dividing pixel values by 8 and 6, then comparing to robot location.
	// Robot location is a single point.
		
	reg 	[11:0] 	matchedrow, matchedcol;	// Initial value of matched display location.
	//reg 	[5:0] 	rowdiff, coldiff;
	reg 	[7:0]    icon_index;	// For indexing through index ROM orietations.
	wire   [6:0]   scaled_row, scaled_col;
	wire   [7:0]   douta0, douta1, douta2, douta3, 
	               douta4, douta5, douta6, douta7;
	               
	//counter
//	reg clear0, enable0;
//	reg clear1, enable1;
	reg [7:0] count_row, count_column;
	reg start_count;
	               	
	// Scaling of the map.
	scale icon_scale(	pixel_row, 
						pixel_column, 
						{scaled_row, scaled_col});
						
//    counter_row count0(clk,
//        reset,
//        clear0,
//        enable0,
//        count_row);
    
//    counter_column count1(clk,
//        reset,
//        clear1,
//        enable1,
//        count_column);

    always@(posedge clk) begin
        if(reset) begin
            count_row <= 0;
            count_column <= 0;
            icon_index <= 8'h0;
//            clear0 = 1;
//            clear1 = 1;
        end
        if(count_row != 8'h3f) begin
                if(count_column == 8'h3f) begin
                    count_row <= count_row + 1;
                    count_column <= 8'h0;
                    end
                else count_column <= count_column + 1;
                end
            else begin
                count_row <= 0;
                start_count <= 0;
                end                        
        end
			
	always@(*)
		begin     
			if((scaled_row == LocY_reg[6:0]) && (scaled_col == LocX_reg[6:0]))
                begin
                    start_count = 1;
                    icon_index = {count_row[5:2], count_column[5:2]};
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
            else begin
                     icon = 2'h0;
                  end
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