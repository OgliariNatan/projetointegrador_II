-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"
-- CREATED		"Wed Aug 16 10:20:50 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY altera;
USE altera.maxplus2.all; 

LIBRARY work;

ENTITY 74190_0 IS 
PORT 
( 
	LDN	:	IN	 STD_LOGIC;
	A	:	IN	 STD_LOGIC;
	C	:	IN	 STD_LOGIC;
	B	:	IN	 STD_LOGIC;
	D	:	IN	 STD_LOGIC;
	GN	:	IN	 STD_LOGIC;
	CLK	:	IN	 STD_LOGIC;
	DNUP	:	IN	 STD_LOGIC;
	QA	:	OUT	 STD_LOGIC;
	QB	:	OUT	 STD_LOGIC;
	QD	:	OUT	 STD_LOGIC;
	QC	:	OUT	 STD_LOGIC
); 
END 74190_0;

ARCHITECTURE bdf_type OF 74190_0 IS 
BEGIN 

-- instantiate macrofunction 

b2v_inst : 74190
PORT MAP(LDN => LDN,
		 A => A,
		 C => C,
		 B => B,
		 D => D,
		 GN => GN,
		 CLK => CLK,
		 DNUP => DNUP,
		 QA => QA,
		 QB => QB,
		 QD => QD,
		 QC => QC);

END bdf_type; 