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

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "04/24/2017 19:57:47"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          trigger
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY trigger_vhd_vec_tst IS
END trigger_vhd_vec_tst;
ARCHITECTURE trigger_arch OF trigger_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL CLOCK : STD_LOGIC;
SIGNAL ENABLE : STD_LOGIC;
SIGNAL PULSE : STD_LOGIC;
COMPONENT trigger
	PORT (
	CLOCK : IN STD_LOGIC;
	ENABLE : IN STD_LOGIC;
	PULSE : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : trigger
	PORT MAP (
-- list connections between master ports and signals
	CLOCK => CLOCK,
	ENABLE => ENABLE,
	PULSE => PULSE
	);

-- CLOCK
t_prcs_CLOCK: PROCESS
BEGIN
LOOP
	CLOCK <= '0';
	WAIT FOR 500000 ps;
	CLOCK <= '1';
	WAIT FOR 500000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLOCK;

-- ENABLE
t_prcs_ENABLE: PROCESS
BEGIN
	ENABLE <= '1';
WAIT;
END PROCESS t_prcs_ENABLE;
END trigger_arch;
