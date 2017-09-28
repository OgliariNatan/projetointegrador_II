LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hc_sr04 IS 
	GENERIC
	(
		freqIn 	: INTEGER 	:= 50000000;
		freqOut	: INTEGER	:= 17000
	);
		
	PORT
	(
		CLOCK_CORE	: IN STD_LOGIC;
		ENABLE		: IN STD_LOGIC;
		ECHO			: IN STD_LOGIC;
		
		TRIGGER	: OUT STD_LOGIC
	
	);
END hc_sr04;

ARCHITECTURE behavior OF hc_sr04 IS

	SIGNAL hc_clock : STD_LOGIC := '0';
	
	BEGIN
	
	HC_SR04_CLOCK:WORK.clockDivider
		PORT MAP(
		CLOCK_CORE,
		freqIn,
		freqOut,
		hc_clock
		);
		
	PROCESS(ENABLE)
	
	CONSTANT COUNT_MAX	: INTEGER 	:= 1000000;
	VARIABLE counter 		: INTEGER RANGE 0 TO COUNT_MAX := 0;
	
	BEGIN
	
		IF (CLOCK_CORE'EVENT AND CLOCK_CORE = '1') THEN
		
			IF counter < COUNT_MAX THEN
				counter := counter + 1;
				TRIGGER <= '1';
			ELSE
				counter 	:= 0;
				TRIGGER	<= '0';
			
			END IF;
		END IF;

	END PROCESS;
	
END;