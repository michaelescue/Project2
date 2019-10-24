// mfp_nexys4_ddr.v
// January 1, 2017
//
// Instantiate the mipsfpga system and rename signals to
// match the GPIO, LEDs and switches on Digilent's (Xilinx)
// Nexys4 DDR board

// Outputs:
// 16 LEDs (IO_LED) 
// Inputs:
// 16 Slide switches (IO_Switch),
// 5 Pushbuttons (IO_PB): {BTNU, BTND, BTNL, BTNC, BTNR}
//

`include "mfp_ahb_const.vh"

module mfp_nexys4_ddr( 
                        input                   CLK100MHZ,
                        input                   CPU_RESETN,
                        input                   BTNU, BTND, BTNL, BTNC, BTNR, 
                        input  [`MFP_N_SW-1 :0] SW,
                        output [`MFP_N_LED-1:0] LED,
                        //output [`MFP_N_SEG-1:0] SEG,
                        output CA, CB, CC, CD, CE, CF, CG, DP,
                        output [7:0] AN,
                        inout  [ 8          :1] JB,
                        input                   UART_TXD_IN);

  // Press btnCpuReset to reset the processor. 
        
  wire tck_in, tck;
  wire [7:0] io_wire;
  wire [5:0] pbtn_db;
  wire [`MFP_N_SW-1 :0] swtch_db;
  wire clk_out1, clk_out2;
  
  // Connections for handshake
   wire IO_INT_ACK;
   wire IO_BotUpdt;
   reg IO_BotUpdt_Sync;
  // wire IO_BotUpdt;
   
   //connections for Rojobot
   wire [7 : 0] MotCtl_in;
   wire [7 : 0] LocX_reg;
   wire [7 : 0] LocY_reg;
   wire [7 : 0] Sensors_reg;
   wire [7 : 0] BotInfo_reg;
   wire [13 : 0] worldmap_addr;
   wire [1 : 0] worldmap_data;
  
  
  assign io_wire = {DP,CA,CB,CC,CD,CE,CF,CG};       
  
  clk_wiz_0 clk_wiz_0
     (
      // Clock out ports
      .clk_out1(clk_out1),      // clk_out1 = 50Mhz Clock
      .clk_out2(clk_out2),      // clk_out2 = 75Mhz Clock
     // Clock in ports
      .clk_in1(CLK100MHZ));      // input clk_in1
  
  IBUF IBUF1(.O(tck_in),.I(JB[4]));
  BUFG BUFG1(.O(tck), .I(tck_in));
  
  debounce debounce(.clk(clk_out1), .pbtn_in({BTNU,BTND,BTNL,BTNC,BTNR,CPU_RESETN}), .switch_in(SW), .pbtn_db(pbtn_db), .swtch_db(swtch_db));



  mfp_sys mfp_sys(
			        .SI_Reset_N(pbtn_db[0]),
                    .SI_ClkIn(clk_out1),        // clk_out1 = 50Mhz Clock
                    .HADDR(),
                    .HRDATA(),
                    .HWDATA(),
                    .HWRITE(),
					.HSIZE(),
                    .EJ_TRST_N_probe(JB[7]),
                    .EJ_TDI(JB[2]),
                    .EJ_TDO(JB[3]),
                    .EJ_TMS(JB[1]),
                    .EJ_TCK(tck),
                    .SI_ColdReset_N(JB[8]),
                    .EJ_DINT(1'b0),
                    .IO_Switch(swtch_db),
                    .IO_PB(pbtn_db[5:1]),
                    .IO_LED(LED),
                    .IO_7SEGEN_N(AN),
                    .IO_SEG_N(io_wire),
                    .UART_RX(UART_TXD_IN),
                    .IO_BotCtrl(MotCtl_in),
                    .IO_BotInfo({LocX_reg, LocY_reg, Sensors_reg, BotInfo_reg}),
                    .IO_INT_ACK(IO_INT_ACK),
                    .IO_BotUpdt_Sync(IO_BotUpdt_Sync)
                    );
wire upd_sysregs;
                         
 //Rojobot instantiation
 rojobot31_0 rojobot(
   .MotCtl_in(MotCtl_in),            // input wire [7 : 0] MotCtl_in
   .LocX_reg(LocX_reg),              // output wire [7 : 0] LocX_reg
   .LocY_reg(LocY_reg),              // output wire [7 : 0] LocY_reg
   .Sensors_reg(Sensors_reg),        // output wire [7 : 0] Sensors_reg
   .BotInfo_reg(BotInfo_reg),        // output wire [7 : 0] BotInfo_reg
   .worldmap_addr(worldmap_addr),    // output wire [13 : 0] worldmap_addr
   .worldmap_data(worldmap_data),    // input wire [1 : 0] worldmap_data
   .clk_in(clk_out2),                  // input wire clk_in     //clk_out2 is the 75Mhz clock from clkwiz0.
   .reset(pbtn_db[0]),                    // input wire reset // Reset is bit 0 of pbtn_db from debounce module. 
   .upd_sysregs(upd_sysregs),        // output wire upd_sysregs
   .Bot_Config_reg(swtch_db)  // input wire [7 : 0] Bot_Config_reg    // Debounced switch signal from debounce module.
 );
 

 
 assign IO_BotUpdt  = upd_sysregs;
 
 //Handshaking Flip-flop
 always @ (posedge clk_out1) begin
         if (IO_INT_ACK == 1'b1) begin
         IO_BotUpdt_Sync <= 1'b0;
     end
     else if (IO_BotUpdt == 1'b1) begin
        IO_BotUpdt_Sync <= 1'b1;
     end else begin
         IO_BotUpdt_Sync <= IO_BotUpdt_Sync;
 end
 
 end // always
  
 // World map instantiation
 world_map world_map(
   .clka(clk_out2),     // 75Mhz clock
   .addra(worldmap_addr),
   .douta(worldmap_data),
   .clkb(clk_out2),
   .addrb(),
   .doutb()
 );
 
 //VGA Instantiation
 //dtg vta(.clock(), .rst(), .horiz_sync(), .vert_sync(), .video_on(),.pixel_row(), .pixel_column());
          
endmodule
