// colorizer module


module colorizer(
	input video_on,
	input [1:0] world_pixel,	// From rojobot
	// input [1:0] icon,
	output reg [3:0] red, green, blue		// output to Colorizer
	);
	
	always@(*)
	begin
		if(video_on)
			begin
				case(world_pixel)
					0:
					begin
						red = 0xF;
						green = 0xF;
						blue = 0xF;
					end
					1:
					begin
						red = 0xF;
						green = 0;
						blue = 0;
					end
					2:
					begin
						red = 0;
						green = 0;
						blue = 0xF;
					end
					default:
						red = 0;
						green = 0;
						blue = 0;
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