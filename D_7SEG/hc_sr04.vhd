LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

--componente para o sensor de altura

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
		FIM_TRIGGER	: OUT STD_LOGIC;
		ECHO			: IN STD_LOGIC;
		TRIGGER		: OUT STD_LOGIC
	
	);
END hc_sr04;

ARCHITECTURE behavior OF hc_sr04 IS

	CONSTANT	COUNT_MAX	: INTEGER 	:= 500;
	SIGNAL	counter 		: INTEGER RANGE 0 TO COUNT_MAX := 0;
	SIGNAL 	hc_clock 	: STD_LOGIC;
	--SIGNAL	FIM_TRIGGER	: STD_LOGIC;
	
	BEGIN
	
	HC_SR04_CLOCK:WORK.clockDivider
		PORT MAP(
		CLOCK_CORE,
		freqIn,
		freqOut,
		hc_clock
		);
	
	PROCESS(ENABLE)
	
	BEGIN
			IF (CLOCK_CORE'EVENT AND CLOCK_CORE = '1') THEN
			
				IF counter < COUNT_MAX THEN
					counter <= counter + 1;
					TRIGGER <= '1';
				ELSE
					counter 		<= 0;
					FIM_TRIGGER	<= '0';
					TRIGGER		<= '0';
				
				END IF;
			END IF;
	END PROCESS;
	
END;