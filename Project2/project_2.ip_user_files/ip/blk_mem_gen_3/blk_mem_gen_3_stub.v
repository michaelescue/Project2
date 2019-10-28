// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2.1 (win64) Build 2288692 Thu Jul 26 18:24:02 MDT 2018
// Date        : Mon Oct 28 10:24:25 2019
// Host        : caplab12 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               n:/ECE540/ECE540_Project2/Project2/project_2.srcs/sources_1/ip/blk_mem_gen_3/blk_mem_gen_3_stub.v
// Design      : blk_mem_gen_3
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2.1" *)
module blk_mem_gen_3(clka, ena, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,addra[8:0],douta[7:0]" */;
  input clka;
  input ena;
  input [8:0]addra;
  output [7:0]douta;
endmodule