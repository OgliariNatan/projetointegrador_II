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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"

-- DATE "04/24/2017 22:24:21"

-- 
-- Device: Altera EP4CE115F29C7 Package FBGA780
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_ASDO_DATA1~	=>  Location: PIN_F4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_FLASH_nCE_nCSO~	=>  Location: PIN_E2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_P3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DATA0~	=>  Location: PIN_N7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCEO~	=>  Location: PIN_P28,	 I/O Standard: 2.5 V,	 Current Strength: 8mA


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~padout\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY ALTERA;
LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	fsm_u_som IS
    PORT (
	CLOCK : IN std_logic;
	RST : IN std_logic;
	E_SINAL_ECHO : IN std_logic;
	E_SINAL_TRIG : IN std_logic;
	E_SINAL_DELAY : IN std_logic;
	S_EN_TRIG : BUFFER std_logic;
	S_RST_ECHO : BUFFER std_logic;
	S_EN_DELAY : BUFFER std_logic
	);
END fsm_u_som;

-- Design Ports Information
-- S_EN_TRIG	=>  Location: PIN_U4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- S_RST_ECHO	=>  Location: PIN_U3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- S_EN_DELAY	=>  Location: PIN_R3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- E_SINAL_TRIG	=>  Location: PIN_R2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- CLOCK	=>  Location: PIN_J1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- RST	=>  Location: PIN_Y2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- E_SINAL_DELAY	=>  Location: PIN_R1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- E_SINAL_ECHO	=>  Location: PIN_R7,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF fsm_u_som IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_CLOCK : std_logic;
SIGNAL ww_RST : std_logic;
SIGNAL ww_E_SINAL_ECHO : std_logic;
SIGNAL ww_E_SINAL_TRIG : std_logic;
SIGNAL ww_E_SINAL_DELAY : std_logic;
SIGNAL ww_S_EN_TRIG : std_logic;
SIGNAL ww_S_RST_ECHO : std_logic;
SIGNAL ww_S_EN_DELAY : std_logic;
SIGNAL \RST~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \CLOCK~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \S_EN_TRIG~output_o\ : std_logic;
SIGNAL \S_RST_ECHO~output_o\ : std_logic;
SIGNAL \S_EN_DELAY~output_o\ : std_logic;
SIGNAL \CLOCK~input_o\ : std_logic;
SIGNAL \CLOCK~inputclkctrl_outclk\ : std_logic;
SIGNAL \E_SINAL_TRIG~input_o\ : std_logic;
SIGNAL \E_SINAL_DELAY~input_o\ : std_logic;
SIGNAL \E_SINAL_ECHO~input_o\ : std_logic;
SIGNAL \Selector5~0_combout\ : std_logic;
SIGNAL \RST~input_o\ : std_logic;
SIGNAL \RST~inputclkctrl_outclk\ : std_logic;
SIGNAL \pr_state.gera_trig~q\ : std_logic;
SIGNAL \Selector6~0_combout\ : std_logic;
SIGNAL \pr_state.espera_echo~feeder_combout\ : std_logic;
SIGNAL \pr_state.espera_echo~q\ : std_logic;
SIGNAL \Selector7~0_combout\ : std_logic;
SIGNAL \pr_state.mede_echo~feeder_combout\ : std_logic;
SIGNAL \pr_state.mede_echo~q\ : std_logic;
SIGNAL \Selector8~0_combout\ : std_logic;
SIGNAL \pr_state.inicia_delay~q\ : std_logic;
SIGNAL \Selector9~0_combout\ : std_logic;
SIGNAL \pr_state.delay~feeder_combout\ : std_logic;
SIGNAL \pr_state.delay~q\ : std_logic;
SIGNAL \Selector3~0_combout\ : std_logic;
SIGNAL \pr_state.inicio~q\ : std_logic;
SIGNAL \Selector4~0_combout\ : std_logic;
SIGNAL \pr_state.inicia_trig~q\ : std_logic;
SIGNAL \WideOr0~0_combout\ : std_logic;
SIGNAL \S_EN_TRIG$latch~combout\ : std_logic;
SIGNAL \WideOr1~0_combout\ : std_logic;
SIGNAL \S_RST_ECHO$latch~combout\ : std_logic;
SIGNAL \WideOr2~0_combout\ : std_logic;
SIGNAL \S_EN_DELAY$latch~combout\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_CLOCK <= CLOCK;
ww_RST <= RST;
ww_E_SINAL_ECHO <= E_SINAL_ECHO;
ww_E_SINAL_TRIG <= E_SINAL_TRIG;
ww_E_SINAL_DELAY <= E_SINAL_DELAY;
S_EN_TRIG <= ww_S_EN_TRIG;
S_RST_ECHO <= ww_S_RST_ECHO;
S_EN_DELAY <= ww_S_EN_DELAY;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\RST~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \RST~input_o\);

\CLOCK~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \CLOCK~input_o\);
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X0_Y34_N16
\S_EN_TRIG~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \S_EN_TRIG$latch~combout\,
	devoe => ww_devoe,
	o => \S_EN_TRIG~output_o\);

-- Location: IOOBUF_X0_Y34_N9
\S_RST_ECHO~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \S_RST_ECHO$latch~combout\,
	devoe => ww_devoe,
	o => \S_RST_ECHO~output_o\);

-- Location: IOOBUF_X0_Y34_N23
\S_EN_DELAY~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \S_EN_DELAY$latch~combout\,
	devoe => ww_devoe,
	o => \S_EN_DELAY~output_o\);

-- Location: IOIBUF_X0_Y36_N8
\CLOCK~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLOCK,
	o => \CLOCK~input_o\);

-- Location: CLKCTRL_G2
\CLOCK~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \CLOCK~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \CLOCK~inputclkctrl_outclk\);

-- Location: IOIBUF_X0_Y35_N1
\E_SINAL_TRIG~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_E_SINAL_TRIG,
	o => \E_SINAL_TRIG~input_o\);

-- Location: IOIBUF_X0_Y35_N8
\E_SINAL_DELAY~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_E_SINAL_DELAY,
	o => \E_SINAL_DELAY~input_o\);

-- Location: IOIBUF_X0_Y35_N15
\E_SINAL_ECHO~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_E_SINAL_ECHO,
	o => \E_SINAL_ECHO~input_o\);

-- Location: LCCOMB_X1_Y35_N0
\Selector5~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector5~0_combout\ = (\E_SINAL_TRIG~input_o\ & ((\pr_state.inicia_trig~q\) # (\pr_state.gera_trig~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \E_SINAL_TRIG~input_o\,
	datac => \pr_state.inicia_trig~q\,
	datad => \pr_state.gera_trig~q\,
	combout => \Selector5~0_combout\);

-- Location: IOIBUF_X0_Y36_N15
\RST~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_RST,
	o => \RST~input_o\);

-- Location: CLKCTRL_G4
\RST~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \RST~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \RST~inputclkctrl_outclk\);

-- Location: FF_X1_Y35_N11
\pr_state.gera_trig\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~inputclkctrl_outclk\,
	asdata => \Selector5~0_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.gera_trig~q\);

-- Location: LCCOMB_X1_Y35_N10
\Selector6~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector6~0_combout\ = (\E_SINAL_ECHO~input_o\ & (!\E_SINAL_TRIG~input_o\ & (\pr_state.gera_trig~q\))) # (!\E_SINAL_ECHO~input_o\ & ((\pr_state.espera_echo~q\) # ((!\E_SINAL_TRIG~input_o\ & \pr_state.gera_trig~q\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111010100110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \E_SINAL_ECHO~input_o\,
	datab => \E_SINAL_TRIG~input_o\,
	datac => \pr_state.gera_trig~q\,
	datad => \pr_state.espera_echo~q\,
	combout => \Selector6~0_combout\);

-- Location: LCCOMB_X1_Y35_N4
\pr_state.espera_echo~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \pr_state.espera_echo~feeder_combout\ = \Selector6~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \Selector6~0_combout\,
	combout => \pr_state.espera_echo~feeder_combout\);

-- Location: FF_X1_Y35_N5
\pr_state.espera_echo\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~inputclkctrl_outclk\,
	d => \pr_state.espera_echo~feeder_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.espera_echo~q\);

-- Location: LCCOMB_X1_Y35_N20
\Selector7~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector7~0_combout\ = (\E_SINAL_ECHO~input_o\ & ((\pr_state.espera_echo~q\) # (\pr_state.mede_echo~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \pr_state.espera_echo~q\,
	datac => \E_SINAL_ECHO~input_o\,
	datad => \pr_state.mede_echo~q\,
	combout => \Selector7~0_combout\);

-- Location: LCCOMB_X1_Y35_N12
\pr_state.mede_echo~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \pr_state.mede_echo~feeder_combout\ = \Selector7~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \Selector7~0_combout\,
	combout => \pr_state.mede_echo~feeder_combout\);

-- Location: FF_X1_Y35_N13
\pr_state.mede_echo\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~input_o\,
	d => \pr_state.mede_echo~feeder_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.mede_echo~q\);

-- Location: LCCOMB_X1_Y35_N22
\Selector8~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector8~0_combout\ = (\pr_state.inicia_delay~q\ & (((\pr_state.mede_echo~q\ & !\E_SINAL_ECHO~input_o\)) # (!\E_SINAL_DELAY~input_o\))) # (!\pr_state.inicia_delay~q\ & (\pr_state.mede_echo~q\ & (!\E_SINAL_ECHO~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000110010101110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pr_state.inicia_delay~q\,
	datab => \pr_state.mede_echo~q\,
	datac => \E_SINAL_ECHO~input_o\,
	datad => \E_SINAL_DELAY~input_o\,
	combout => \Selector8~0_combout\);

-- Location: FF_X1_Y35_N15
\pr_state.inicia_delay\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~inputclkctrl_outclk\,
	asdata => \Selector8~0_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.inicia_delay~q\);

-- Location: LCCOMB_X1_Y35_N28
\Selector9~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector9~0_combout\ = (\E_SINAL_DELAY~input_o\ & ((\pr_state.delay~q\) # (\pr_state.inicia_delay~q\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101010001000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \E_SINAL_DELAY~input_o\,
	datab => \pr_state.delay~q\,
	datad => \pr_state.inicia_delay~q\,
	combout => \Selector9~0_combout\);

-- Location: LCCOMB_X1_Y35_N2
\pr_state.delay~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \pr_state.delay~feeder_combout\ = \Selector9~0_combout\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011001100",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \Selector9~0_combout\,
	combout => \pr_state.delay~feeder_combout\);

-- Location: FF_X1_Y35_N3
\pr_state.delay\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~inputclkctrl_outclk\,
	d => \pr_state.delay~feeder_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.delay~q\);

-- Location: LCCOMB_X1_Y35_N16
\Selector3~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector3~0_combout\ = (\E_SINAL_DELAY~input_o\) # (!\pr_state.delay~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \E_SINAL_DELAY~input_o\,
	datad => \pr_state.delay~q\,
	combout => \Selector3~0_combout\);

-- Location: FF_X1_Y35_N17
\pr_state.inicio\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~input_o\,
	d => \Selector3~0_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.inicio~q\);

-- Location: LCCOMB_X1_Y35_N14
\Selector4~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \Selector4~0_combout\ = ((!\E_SINAL_TRIG~input_o\ & \pr_state.inicia_trig~q\)) # (!\pr_state.inicio~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111011100110011",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \E_SINAL_TRIG~input_o\,
	datab => \pr_state.inicio~q\,
	datad => \pr_state.inicia_trig~q\,
	combout => \Selector4~0_combout\);

-- Location: FF_X1_Y35_N29
\pr_state.inicia_trig\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \CLOCK~inputclkctrl_outclk\,
	asdata => \Selector4~0_combout\,
	clrn => \RST~inputclkctrl_outclk\,
	sload => VCC,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state.inicia_trig~q\);

-- Location: LCCOMB_X1_Y35_N24
\WideOr0~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideOr0~0_combout\ = (\pr_state.inicia_trig~q\) # (!\pr_state.inicio~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100110011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \pr_state.inicia_trig~q\,
	datad => \pr_state.inicio~q\,
	combout => \WideOr0~0_combout\);

-- Location: LCCOMB_X1_Y35_N8
\S_EN_TRIG$latch\ : cycloneive_lcell_comb
-- Equation(s):
-- \S_EN_TRIG$latch~combout\ = (\WideOr0~0_combout\ & (\pr_state.inicia_trig~q\)) # (!\WideOr0~0_combout\ & ((\S_EN_TRIG$latch~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pr_state.inicia_trig~q\,
	datac => \S_EN_TRIG$latch~combout\,
	datad => \WideOr0~0_combout\,
	combout => \S_EN_TRIG$latch~combout\);

-- Location: LCCOMB_X1_Y35_N6
\WideOr1~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideOr1~0_combout\ = (\pr_state.mede_echo~q\) # ((\pr_state.espera_echo~q\) # (!\pr_state.inicio~q\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111101011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pr_state.mede_echo~q\,
	datac => \pr_state.espera_echo~q\,
	datad => \pr_state.inicio~q\,
	combout => \WideOr1~0_combout\);

-- Location: LCCOMB_X1_Y35_N26
\S_RST_ECHO$latch\ : cycloneive_lcell_comb
-- Equation(s):
-- \S_RST_ECHO$latch~combout\ = (\WideOr1~0_combout\ & (\pr_state.espera_echo~q\)) # (!\WideOr1~0_combout\ & ((\S_RST_ECHO$latch~combout\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \pr_state.espera_echo~q\,
	datac => \S_RST_ECHO$latch~combout\,
	datad => \WideOr1~0_combout\,
	combout => \S_RST_ECHO$latch~combout\);

-- Location: LCCOMB_X1_Y35_N18
\WideOr2~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \WideOr2~0_combout\ = (\pr_state.inicia_delay~q\) # (!\pr_state.inicio~q\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \pr_state.inicia_delay~q\,
	datad => \pr_state.inicio~q\,
	combout => \WideOr2~0_combout\);

-- Location: LCCOMB_X1_Y35_N30
\S_EN_DELAY$latch\ : cycloneive_lcell_comb
-- Equation(s):
-- \S_EN_DELAY$latch~combout\ = (\WideOr2~0_combout\ & ((\pr_state.inicia_delay~q\))) # (!\WideOr2~0_combout\ & (\S_EN_DELAY$latch~combout\))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111000010101010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \S_EN_DELAY$latch~combout\,
	datac => \pr_state.inicia_delay~q\,
	datad => \WideOr2~0_combout\,
	combout => \S_EN_DELAY$latch~combout\);

ww_S_EN_TRIG <= \S_EN_TRIG~output_o\;

ww_S_RST_ECHO <= \S_RST_ECHO~output_o\;

ww_S_EN_DELAY <= \S_EN_DELAY~output_o\;
END structure;


