
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	MAQUINA DE ESTADOS DO SENSOR HCSR04
--														
--		AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		ABRIL DE 2017

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY trigger IS

	GENERIC (PULSE_WIDTH : INTEGER := 1);
	PORT (
		CLOCK, ENABLE:		IN STD_LOGIC;
		PULSE:			 	OUT STD_LOGIC
	);
END trigger;



ARCHITECTURE HARDWARE OF trigger IS

	SIGNAL pulse_value: STD_LOGIC :='0' ;
	
	BEGIN
	PROCESS (CLOCK)
		
		VARIABLE counter:	INTEGER RANGE 0 TO PULSE_WIDTH := 0;
		BEGIN
			IF (CLOCK'EVENT AND CLOCK='1') THEN
				
				IF (ENABLE = '0') THEN
					counter := 0;
					pulse_value <= '0';
				
				ELSE
				
					IF (counter < PULSE_WIDTH) THEN
						counter := counter + 1;
						pulse_value <= '1';
					ELSE
						pulse_value <=  '0';					
					END IF;
				END IF;
			END IF;
		END PROCESS;
	PULSE <= pulse_value;
END HARDWARE;