
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	DECODER 7SEGMENTOS								
--														
-- 	AUTORES: 	JEFERSON PEDROSO
--						TARCIS BECHER

--		ABRIL DE 2017



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sen_alt_7seg IS PORT(

		CLOCK_IN:	IN STD_LOGIC;
		ECHO:			IN STD_LOGIC;
		TRIGGER:		OUT STD_LOGIC;
		DISPLAY_UNI:OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		DISPLAY_DEZ:OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
END;



ARCHITECTURE HARDWARE OF sen_alt_7seg IS

	SIGNAL VEC_BIN	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL BCD_SIG : STD_LOGIC_VECTOR (9 DOWNTO 0);
	SIGNAL SIG_UNI : STD_LOGIC_VECTOR (3 DOWNTO 0);-- := "0000";
	SIGNAL SIG_DEZ : STD_LOGIC_VECTOR (3 DOWNTO 0);-- := "0000";

	BEGIN

	SIG_UNI <= BCD_SIG (3 DOWNTO 0);
	SIG_DEZ <= BCD_SIG (7 DOWNTO 4);
	
	
	BLOCO_01: WORK.sens_alt
		PORT MAP(CLOCK_IN, ECHO, TRIGGER, VEC_BIN);
				--(CLOCK_50, ECHO, TRIG, VALOR)
	
	BLOCO_02: WORK.classificador
		PORT MAP(VEC_BIN, BCD_SIG);			
				--(CONT_PULSE, BCD)
		
	BLOCO_03: WORK.decode7seg
		PORT MAP(SIG_UNI, SIG_DEZ, DISPLAY_UNI, DISPLAY_DEZ);
		
				--(BCD_UNI, BCD_DEZ, SEG7_UNI, SEG7_DEZ)
	
			
END HARDWARE;