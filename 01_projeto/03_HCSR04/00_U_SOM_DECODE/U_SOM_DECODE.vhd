
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	SENSOR HCSR04 + DECODE 7SEGMENTOS
--														
-- 	AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		ABRIL DE 2017


LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY U_SOM_DECODE IS
	PORT (
		CLOCK_IN:	IN BIT;
		RESET:		IN STD_LOGIC; 
		ECHO:			IN STD_LOGIC;
		TRIGGER:		OUT STD_LOGIC;
		DISPLAY_UNI:OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		DISPLAY_DEZ:OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
	);
END;


ARCHITECTURE HARDWARE OF U_SOM_DECODE IS

	SIGNAL BCD_SIG : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL SIG_UNI : STD_LOGIC_VECTOR (3 DOWNTO 0);-- := "0000";
	SIGNAL SIG_DEZ : STD_LOGIC_VECTOR (3 DOWNTO 0);-- := "0000";

	BEGIN
	
		SIG_UNI <= BCD_SIG (3 DOWNTO 0);
		SIG_DEZ <= BCD_SIG (7 DOWNTO 4);
	
		BLOCO_01: WORK.u_som
			PORT MAP(CLOCK_IN, RESET, ECHO, TRIGGER, BCD_SIG);
			
		BLOCO_02: WORK.decode7seg
			PORT MAP(SIG_UNI, SIG_DEZ, DISPLAY_UNI, DISPLAY_DEZ);
			
			
END HARDWARE;