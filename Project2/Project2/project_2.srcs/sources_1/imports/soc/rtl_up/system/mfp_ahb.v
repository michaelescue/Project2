// mfp_ahb.v
// 
// January 1, 2017
//
// AHB-lite bus module with 3 slaves: boot RAM, program RAM, and
// GPIO (memory-mapped I/O: switches and LEDs from the FPGA board).
// The module includes an address decoder and multiplexer (for 
// selecting which slave module produces HRDATA).

`include "mfp_ahb_const.vh"


module mfp_ahb
(
    input                       HCLK,
    input                       HRESETn,
    input      [ 31         :0] HADDR,
    input      [  2         :0] HBURST,
    input                       HMASTLOCK,
    input      [  3         :0] HPROT,
    input      [  2         :0] HSIZE,
    input      [  1         :0] HTRANS,
    input      [ 31         :0] HWDATA,
    input                       HWRITE,
    output     [ 31         :0] HRDATA,
    output                      HREADY,
    output                      HRESP,
    input                       SI_Endian,

// memory-mapped I/O
    input      [`MFP_N_SW-1 :0] IO_Switch,
    input      [`MFP_N_PB-1 :0] IO_PB,
    output     [`MFP_N_LED-1:0] IO_LED,
    output     [`MFP_N_SEG-1:0] IO_7SEGEN_N,
    output     [`MFP_N_SEG-1:0] IO_SEG_N   
);


  wire [31:0] HRDATA2, HRDATA1, HRDATA0;
  wire [ 3:0] HSEL;
  reg  [ 3:0] HSEL_d;
//  wire [ 7:0] en;

  assign HREADY = 1;
  assign HRESP = 0;

	
  // Delay select signal to align for reading data
  always @(posedge HCLK)
    HSEL_d <= HSEL;

  // Module 0 - boot ram
  mfp_ahb_b_ram mfp_ahb_b_ram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                              HTRANS, HWDATA, HWRITE, HRDATA0, HSEL[0]);
  // Module 1 - program ram
  mfp_ahb_p_ram mfp_ahb_p_ram(HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HSIZE,
                              HTRANS, HWDATA, HWRITE, HRDATA1, HSEL[1]);
  // Module 2 - GPIO
  mfp_ahb_gpio mfp_ahb_gpio(HCLK, HRESETn, HADDR[5:2], HTRANS, HWDATA, HWRITE, HSEL[2], 
                            HRDATA2, IO_Switch, IO_PB, IO_LED);
  
  // Module 3 - seven segment
  //mfp_ahb_sevensegtimer mfp_ahb_sseg(.clk(HCLK), .resetn(HRESETn), .EN(), .HWDATA(), .HWRITE(), .HSEL[3](), .{DISPOUT,DISPENOUT}(IO_SEG));                          
    mfp_ahb_7seg mfp_ahb_sseg(HCLK, HRESETn, HADDR, HWDATA, HWRITE, HSEL[3], 
                              IO_7SEGEN_N,IO_SEG_N);// .EN(), .HWDATA(), .HWRITE(), .HSEL[3](), .{DISPOUT,DISPENOUT}(IO_SEG));                 
 
  ahb_decoder ahb_decoder(HADDR, HSEL);
  ahb_mux ahb_mux(HCLK, HSEL_d, HRDATA2, HRDATA1, HRDATA0, HRDATA);

endmodule


module ahb_decoder
(
    input  [31:0] HADDR,
    output [ 3:0] HSEL
);

  // Decode based on most significant bits of the address
  assign HSEL[0] = (HADDR[28:22] == `H_RAM_RESET_ADDR_Match); // 128 KB RAM  at 0xbfc00000 (physical: 0x1fc00000)
  assign HSEL[1] = (HADDR[28]    == `H_RAM_ADDR_Match);       // 256 KB RAM at 0x80000000 (physical: 0x00000000)
  assign HSEL[2] = (HADDR[28:22] == `H_LED_ADDR_Match);       // GPIO at 0xbf800000 (physical: 0x1f800000)
  assign HSEL[3] = (HADDR[28:22] == `H_SSEG_ADDR_Match);     // Added sseg IO for project1. GPIO at 0xbf700000 (physical: 0x1f700000)
endmodule


module ahb_mux
(
    input             HCLK,
    input      [ 3:0] HSEL,
    input      [31:0] HRDATA2, HRDATA1, HRDATA0,
    output reg [31:0] HRDATA
);

    always @(*)
      casez (HSEL)
	      3'b??1:    HRDATA = HRDATA0;
	      3'b?10:    HRDATA = HRDATA1;
	      3'b100:    HRDATA = HRDATA2;
	      default:   HRDATA = HRDATA1;
      endcase
endmodule
