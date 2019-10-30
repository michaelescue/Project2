-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2.1 (win64) Build 2288692 Thu Jul 26 18:24:02 MDT 2018
-- Date        : Tue Oct 29 18:36:21 2019
-- Host        : caplab12 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               N:/ECE540/ECE540_Project2/Project2/project_2.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_stub.vhdl
-- Design      : blk_mem_gen_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity blk_mem_gen_1 is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 7 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end blk_mem_gen_1;

architecture stub of blk_mem_gen_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,addra[7:0],douta[1:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_1,Vivado 2018.2.1";
begin
end;
