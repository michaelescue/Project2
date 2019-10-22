// 
// mfp_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

//---------------------------------------------------
// Physical bit-width of memory-mapped I/O interfaces
//---------------------------------------------------
`define MFP_N_LED             16
`define MFP_N_SW              16
`define MFP_N_PB              5
`define MFP_N_SEG             8


//---------------------------------------------------
// Memory-mapped I/O addresses
//---------------------------------------------------
`define H_LED_ADDR    			(32'h1f800000) //00'00_00'00
`define H_SW_ADDR   			(32'h1f800004) //00'00_01'00
`define H_PB_ADDR   			(32'h1f800008) //00'00_10'00

//SSEG
`define H_SEG_ADDR_en                    (32'h1F70_0000)
`define H_SEG_ADDR_digit3_0              (32'h1F70_0008)
`define H_SEG_ADDR_digit7_4              (32'h1F70_0004)
`define H_SEG_ADDR_dp                    (32'h1F70_000C)

//Rojobot
`define H_PORT_BOTINFO_ADDR         (4'h3)//(32'h1f80000c)   //00'00_11'00 3
`define H_PORT_BOTCTRL_ADDR         (4'h4)//(32'h1f800010)   //00'01_00'00
`define H_PORT_BOTUPDT_ADDR	        (4'h5)//(32'h1f800014)  //00'01_01'00
`define H_PORT_INTACK_ADDR		    (4'h6)//(32'h1f800018)  //00'01_10'00

`define H_LED_IONUM   			(4'h0)
`define H_SW_IONUM  			(4'h1)
`define H_PB_IONUM  			(4'h2)

//---------------------------------------------------
// RAM addresses
//---------------------------------------------------
`define H_RAM_RESET_ADDR 		(32'h1fc?????)
`define H_RAM_ADDR	 		    (32'h0???????)
`define H_RAM_RESET_ADDR_WIDTH  (8) 
`define H_RAM_ADDR_WIDTH		(16) 

`define H_RAM_RESET_ADDR_Match  (7'h7f)
`define H_RAM_ADDR_Match 		(1'b0)
`define H_LED_ADDR_Match		(7'h7e)
`define H_SSEG_ADDR_Match       (7'h7d)

//---------------------------------------------------
// AHB-Lite values used by MIPSfpga core
//---------------------------------------------------

`define HTRANS_IDLE    2'b00
`define HTRANS_NONSEQ  2'b10
`define HTRANS_SEQ     2'b11

`define HBURST_SINGLE  3'b000
`define HBURST_WRAP4   3'b010

`define HSIZE_1        3'b000
`define HSIZE_2        3'b001
`define HSIZE_4        3'b010
