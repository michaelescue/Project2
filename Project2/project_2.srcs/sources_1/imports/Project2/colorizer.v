// colorizer module


module colorizer(
	input video_on,
	input [1:0] world_pixel,	// From rojobot
	input [1:0] icon,
	output reg [3:0] red, green, blue		// output to Colorizer
	);
	
	always@(*)
	begin
		if(video_on)
			begin
			 if(icon == 2'b01)
                begin
                    red = 4'hF;
                    green = 4'hF;
                    blue = 0;
                end	             
			 else
				case(world_pixel)
					0:
					begin
						red = 4'hF;
						green = 4'hF;
						blue = 4'hF;
					end
					1:
					begin
						red = 4'h8;
						green = 4'hA;
						blue = 0;
					end
					2:
					begin
						red = 4'hF;
						green = 0;
						blue = 0;
					end
					3:
					begin
						red = 0;
						green = 0;
						blue = 0;
					end
				endcase
			end
		else
			begin
				red = 0;
				green = 0;
				blue = 0;
			end	
	end
endmodule