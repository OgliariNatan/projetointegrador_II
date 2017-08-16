--Arquivo para mostrar informações no display de 7 segmentos, no kit DE2-115
--"correndo os dados"
--chip: EP4CE115F29C7N
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY display_7SEG IS
	GENERIC(	freqIn			: INTEGER := 50000000;
				delay				: INTEGER := 100;
				defaultState	: STD_LOGIC := '0'
	);
	PORT(	--Sinais de entrada
			clockIn		: IN STD_LOGIC;
			buttonIn		: IN STD_LOGIC;
			--Sinais de saida
			buttonOut	: OUT STD_LOGIC
	);
END;

ARCHITECTURE display of display_7SEG IS
	--blá blá

	PROCESS(clockin)--Para deixar o codigo em serie
	BEGIN
	--blá blá
	
	
	END PROCESS
END;



