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
-- Generated on "04/24/2017 21:10:25"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          fsm_u_som
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY fsm_u_som_vhd_vec_tst IS
END fsm_u_som_vhd_vec_tst;
ARCHITECTURE fsm_u_som_arch OF fsm_u_som_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL CLOCK : STD_LOGIC;
SIGNAL E_SINAL_DELAY : STD_LOGIC;
SIGNAL E_SINAL_ECHO : STD_LOGIC;
SIGNAL E_SINAL_TRIG : STD_LOGIC;
SIGNAL RST : STD_LOGIC;
SIGNAL S_EN_DELAY : STD_LOGIC;
SIGNAL S_EN_TRIG : STD_LOGIC;
SIGNAL S_RST_ECHO : STD_LOGIC;
COMPONENT fsm_u_som
	PORT (
	CLOCK : IN STD_LOGIC;
	E_SINAL_DELAY : IN STD_LOGIC;
	E_SINAL_ECHO : IN STD_LOGIC;
	E_SINAL_TRIG : IN STD_LOGIC;
	RST : IN STD_LOGIC;
	S_EN_DELAY : BUFFER STD_LOGIC;
	S_EN_TRIG : BUFFER STD_LOGIC;
	S_RST_ECHO : BUFFER STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : fsm_u_som
	PORT MAP (
-- list connections between master ports and signals
	CLOCK => CLOCK,
	E_SINAL_DELAY => E_SINAL_DELAY,
	E_SINAL_ECHO => E_SINAL_ECHO,
	E_SINAL_TRIG => E_SINAL_TRIG,
	RST => RST,
	S_EN_DELAY => S_EN_DELAY,
	S_EN_TRIG => S_EN_TRIG,
	S_RST_ECHO => S_RST_ECHO
	);

-- CLOCK
t_prcs_CLOCK: PROCESS
BEGIN
LOOP
	CLOCK <= '0';
	WAIT FOR 10000 ps;
	CLOCK <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_CLOCK;

-- E_SINAL_DELAY
t_prcs_E_SINAL_DELAY: PROCESS
BEGIN
	E_SINAL_DELAY <= '0';
WAIT;
END PROCESS t_prcs_E_SINAL_DELAY;

-- E_SINAL_ECHO
t_prcs_E_SINAL_ECHO: PROCESS
BEGIN
	E_SINAL_ECHO <= '0';
WAIT;
END PROCESS t_prcs_E_SINAL_ECHO;

-- E_SINAL_TRIG
t_prcs_E_SINAL_TRIG: PROCESS
BEGIN
	FOR i IN 1 TO 3
	LOOP
		E_SINAL_TRIG <= '0';
		WAIT FOR 150000 ps;
		E_SINAL_TRIG <= '1';
		WAIT FOR 150000 ps;
	END LOOP;
	E_SINAL_TRIG <= '0';
WAIT;
END PROCESS t_prcs_E_SINAL_TRIG;

-- RST
t_prcs_RST: PROCESS
BEGIN
	RST <= '1';
WAIT;
END PROCESS t_prcs_RST;
END fsm_u_som_arch;
