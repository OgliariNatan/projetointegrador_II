
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	MAQUINA DE ESTADOS DO SENSOR HCSR04
--														
-- 	AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		ABRIL DE 2017


LIBRARY ieee;
USE ieee.std_logic_1164.all;



ENTITY delay IS

	GENERIC (DELAY_WIDTH : INTEGER := 1020);

	PORT(
		CLOCK, ENABLE: IN STD_LOGIC;
		DELAY:			OUT STD_LOGIC
	);

END delay;




ARCHITECTURE HARDWARE OF delay IS

	SIGNAL delay_value: STD_LOGIC :='0' ;

	BEGIN
		PROCESS (CLOCK)
		VARIABLE counter : INTEGER RANGE 0 TO DELAY_WIDTH := 0;
		BEGIN
			IF (CLOCK'EVENT AND CLOCK='1') THEN
				IF (ENABLE = '0') THEN
					counter := 0;
					delay_value <= '0';
				
				ELSE
				
					IF (counter < DELAY_WIDTH) THEN
						counter := counter + 1;
						delay_value <= '1';
					ELSE
						delay_value <=  '0';
						
					END IF;
				END IF;
			END IF;
		END PROCESS;
		
	DELAY <= delay_value;
	
END HARDWARE;