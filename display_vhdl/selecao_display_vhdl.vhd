LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY selecao_display_vhdl IS 

	PORT
	(
		chave_selecao	:	STD_LOGIC;
		modo_selecao	:  STD_LOGIC;
	)

END selecao_display_vhdl;

ARCHITECTURE DISPLAY_SELECAO OF selecao_display_vhdl IS

	PROCESS(chave_selecao, modo_selecao)
	BEGIN
		IF chave_selecao = '1' THEN
		
		

END DISPLAY_SELECAO;