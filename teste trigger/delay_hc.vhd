LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;




ENTITY delay_hc IS

	PORT	 ( CLOCKIN	: IN 	STD_LOGIC;

				
			   READY	: OUT STD_LOGIC
			  );
			  
END delay_hc;




ARCHITECTURE behavior OF delay_hc IS

	--SIGNAL   clock			: STD_LOGIC := '0';
	CONSTANT COUNT_MAX	: INTEGER 	:= 1000000;

	BEGIN
	
	PROCESS(CLOCKIN)
	
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX := 0;
	
	BEGIN
	
		IF (CLOCKIN'EVENT AND CLOCKIN = '1') THEN
		
			IF counter < COUNT_MAX THEN
				counter := counter + 1;
			ELSE
				counter := 0;
				READY <= '1';
			
			END IF;
		END IF;
	END PROCESS;
END;