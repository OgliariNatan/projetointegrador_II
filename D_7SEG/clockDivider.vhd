LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;




ENTITY clockDivider IS

	PORT	 ( CLOCKIN	: IN STD_LOGIC;
				FreqIn	: IN INTEGER;
				freqOut	: IN INTEGER;
				
			   CLOCKOUT	: OUT STD_LOGIC
			  );
			  
END clockDivider;




ARCHITECTURE behavior OF clockDivider IS

	SIGNAL   clock			: STD_LOGIC := '0';
	CONSTANT COUNT_MAX	: INTEGER 	:= ((freqIn / freqOut) / 2) - 1;

	BEGIN
	
	PROCESS(CLOCKIN)
	
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX := 0;
	
	BEGIN
	
		IF (CLOCKIN'EVENT AND CLOCKIN = '1') THEN
		
			IF counter < COUNT_MAX THEN
				counter := counter + 1;
			ELSE
				counter := 0;
				clock   <= NOT clock;
			
			END IF;
		END IF;
	END PROCESS;
	CLOCKOUT <= clock;
END;