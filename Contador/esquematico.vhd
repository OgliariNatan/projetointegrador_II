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

LIBRARY work;

ENTITY esquematico IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		KEY :  IN  STD_LOGIC_VECTOR(1 TO 1);
		LEDR :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END esquematico;

ARCHITECTURE bdf_type OF esquematico IS 

ATTRIBUTE black_box : BOOLEAN;
ATTRIBUTE noopt : BOOLEAN;

COMPONENT \74190_0\
	PORT(LDN : IN STD_LOGIC;
		 A : IN STD_LOGIC;
		 C : IN STD_LOGIC;
		 B : IN STD_LOGIC;
		 D : IN STD_LOGIC;
		 GN : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 DNUP : IN STD_LOGIC;
		 QA : OUT STD_LOGIC;
		 QB : OUT STD_LOGIC;
		 QD : OUT STD_LOGIC;
		 QC : OUT STD_LOGIC);
END COMPONENT;
ATTRIBUTE black_box OF \74190_0\: COMPONENT IS true;
ATTRIBUTE noopt OF \74190_0\: COMPONENT IS true;

COMPONENT divis
	PORT(clock : IN STD_LOGIC;
		 cout : OUT STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(27 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_7 <= '0';



b2v_inst : 74190_0
PORT MAP(LDN => KEY(1),
		 A => SYNTHESIZED_WIRE_7,
		 C => SYNTHESIZED_WIRE_7,
		 B => SYNTHESIZED_WIRE_7,
		 D => SYNTHESIZED_WIRE_7,
		 GN => SYNTHESIZED_WIRE_7,
		 CLK => SYNTHESIZED_WIRE_5,
		 DNUP => SYNTHESIZED_WIRE_7,
		 QA => LEDR(0),
		 QB => LEDR(1),
		 QD => LEDR(3),
		 QC => LEDR(2));



b2v_inst2 : divis
PORT MAP(clock => CLOCK_50,
		 cout => SYNTHESIZED_WIRE_5);


END bdf_type;