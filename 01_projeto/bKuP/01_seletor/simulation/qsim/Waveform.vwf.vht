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
-- Generated on "03/19/2017 22:25:29"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          SELETOR
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY SELETOR_vhd_vec_tst IS
END SELETOR_vhd_vec_tst;
ARCHITECTURE SELETOR_arch OF SELETOR_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL BOTAO : STD_LOGIC;
SIGNAL SEL : STD_LOGIC_VECTOR(2 DOWNTO 0);
COMPONENT SELETOR
	PORT (
	BOTAO : IN STD_LOGIC;
	SEL : BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : SELETOR
	PORT MAP (
-- list connections between master ports and signals
	BOTAO => BOTAO,
	SEL => SEL
	);

-- BOTAO
t_prcs_BOTAO: PROCESS
BEGIN
LOOP
	BOTAO <= '0';
	WAIT FOR 50000 ps;
	BOTAO <= '1';
	WAIT FOR 50000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_BOTAO;
END SELETOR_arch;
