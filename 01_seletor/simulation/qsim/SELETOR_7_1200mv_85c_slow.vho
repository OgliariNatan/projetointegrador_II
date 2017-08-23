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

-- DATE "03/20/2017 10:57:09"

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

ENTITY 	SELETOR IS
    PORT (
	BOTAO : IN std_logic;
	SAIDA : OUT std_logic_vector(2 DOWNTO 0)
	);
END SELETOR;

-- Design Ports Information
-- SAIDA[0]	=>  Location: PIN_Y4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SAIDA[1]	=>  Location: PIN_Y3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- SAIDA[2]	=>  Location: PIN_AC2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- BOTAO	=>  Location: PIN_J1,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF SELETOR IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_BOTAO : std_logic;
SIGNAL ww_SAIDA : std_logic_vector(2 DOWNTO 0);
SIGNAL \BOTAO~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \SAIDA[0]~output_o\ : std_logic;
SIGNAL \SAIDA[1]~output_o\ : std_logic;
SIGNAL \SAIDA[2]~output_o\ : std_logic;
SIGNAL \BOTAO~input_o\ : std_logic;
SIGNAL \BOTAO~inputclkctrl_outclk\ : std_logic;
SIGNAL \ESTADO.CASO_02~0_combout\ : std_logic;
SIGNAL \ESTADO.CASO_02~q\ : std_logic;
SIGNAL \ESTADO.CASO_03~feeder_combout\ : std_logic;
SIGNAL \ESTADO.CASO_03~q\ : std_logic;
SIGNAL \ESTADO.CASO_01~0_combout\ : std_logic;
SIGNAL \ESTADO.CASO_01~q\ : std_logic;
SIGNAL \ALT_INV_ESTADO.CASO_01~q\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_BOTAO <= BOTAO;
SAIDA <= ww_SAIDA;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\BOTAO~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \BOTAO~input_o\);
\ALT_INV_ESTADO.CASO_01~q\ <= NOT \ESTADO.CASO_01~q\;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X0_Y24_N9
\SAIDA[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ALT_INV_ESTADO.CASO_01~q\,
	devoe => ww_devoe,
	o => \SAIDA[0]~output_o\);

-- Location: IOOBUF_X0_Y24_N16
\SAIDA[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ESTADO.CASO_02~q\,
	devoe => ww_devoe,
	o => \SAIDA[1]~output_o\);

-- Location: IOOBUF_X0_Y24_N23
\SAIDA[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \ESTADO.CASO_03~q\,
	devoe => ww_devoe,
	o => \SAIDA[2]~output_o\);

-- Location: IOIBUF_X0_Y36_N8
\BOTAO~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_BOTAO,
	o => \BOTAO~input_o\);

-- Location: CLKCTRL_G2
\BOTAO~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \BOTAO~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \BOTAO~inputclkctrl_outclk\);

-- Location: LCCOMB_X1_Y24_N6
\ESTADO.CASO_02~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \ESTADO.CASO_02~0_combout\ = !\ESTADO.CASO_01~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \ESTADO.CASO_01~q\,
	combout => \ESTADO.CASO_02~0_combout\);

-- Location: FF_X1_Y24_N7
\ESTADO.CASO_02\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \BOTAO~inputclkctrl_outclk\,
	d => \ESTADO.CASO_02~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ESTADO.CASO_02~q\);

-- Location: LCCOMB_X1_Y24_N28
\ESTADO.CASO_03~feeder\ : cycloneive_lcell_comb
-- Equation(s):
-- \ESTADO.CASO_03~feeder_combout\ = \ESTADO.CASO_02~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \ESTADO.CASO_02~q\,
	combout => \ESTADO.CASO_03~feeder_combout\);

-- Location: FF_X1_Y24_N29
\ESTADO.CASO_03\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \BOTAO~inputclkctrl_outclk\,
	d => \ESTADO.CASO_03~feeder_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ESTADO.CASO_03~q\);

-- Location: LCCOMB_X1_Y24_N16
\ESTADO.CASO_01~0\ : cycloneive_lcell_comb
-- Equation(s):
-- \ESTADO.CASO_01~0_combout\ = !\ESTADO.CASO_03~q\

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datad => \ESTADO.CASO_03~q\,
	combout => \ESTADO.CASO_01~0_combout\);

-- Location: FF_X1_Y24_N17
\ESTADO.CASO_01\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \BOTAO~inputclkctrl_outclk\,
	d => \ESTADO.CASO_01~0_combout\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \ESTADO.CASO_01~q\);

ww_SAIDA(0) <= \SAIDA[0]~output_o\;

ww_SAIDA(1) <= \SAIDA[1]~output_o\;

ww_SAIDA(2) <= \SAIDA[2]~output_o\;
END structure;


