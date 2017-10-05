LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

--componente para o sensor de altura

ENTITY hc_sr04 IS 
	GENERIC
	(
		freqIn 		: INTEGER 	:= 50000000;
		HC_freqOut	: INTEGER	:= 17000;
		count_out	: INTEGER	:= 1000000
	);
		
	PORT
	(
		CLOCK_CORE	: IN 	STD_LOGIC;
		INIT_KEY		: IN	STD_LOGIC;
		ECHO			: IN 	STD_LOGIC;
		TRIGGER		: OUT STD_LOGIC;
		DIST			: OUT	INTEGER
	
	);
END hc_sr04;

ARCHITECTURE behavior OF hc_sr04 IS

	CONSTANT	COUNT_MAX		: INTEGER 	:= 500; --10us
	CONSTANT MAX_DIST			: INTEGER	:= 200;
	CONSTANT DISP_TRIGGER 	: integer := 0;
	CONSTANT WAIT_ECHO  		: integer := 1;
	CONSTANT STANDBY			: integer := 2;
	--CONSTANT DELAY 			: integer := 3;
	--CONSTANT RESET			: integer := 4;
	
	
	SIGNAL	dist_mm		: INTEGER;
	SIGNAL 	hc_clock 	: STD_LOGIC;
	SIGNAL 	count_clock : STD_LOGIC;

	
	BEGIN
	
		PROCESS(CLOCK_CORE)
		
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX := 0;
		
		BEGIN
		
			IF (CLOCK_CORE'EVENT AND CLOCK_CORE = '1') THEN
			
				IF counter < COUNT_MAX THEN
					counter := counter + 1;
				ELSE
					counter := 0;
					hc_clock   <= NOT hc_clock;
				
				END IF;
			END IF;
		END PROCESS;
		count_clock <= hc_clock;
		
--		HC_SR04_CLOCK:WORK.clockDivider
--		
--			PORT MAP(
--			CLOCK_CORE,
--			freqIn,
--			count_out,
--			count_clock
--			);
		
		PROCESS(count_clock, echo)
	
		VARIABLE STATE			:	INTEGER RANGE 0 TO 2 := 0;
		VARIABLE NEXT_STATE	:	INTEGER RANGE 0 TO 2 := 0;
		
		VARIABLE	counter 		: INTEGER RANGE 0 TO COUNT_MAX := 0;
		
		BEGIN
	
			IF(INIT_KEY = '1') THEN
				
				CASE STATE IS
				
					WHEN DISP_TRIGGER =>
					
						TRIGGER <= '1';
						counter := counter + 1;
						
						IF (counter>10) THEN
							counter := 0;
							TRIGGER <= '0';
							NEXT_STATE := WAIT_ECHO;
						END IF;
					
					WHEN WAIT_ECHO =>
						IF(ECHO = '1' ) THEN
						
							counter := counter + 1;
						
						END IF;
						
						IF(ECHO = '0' AND counter>0) THEN
							dist_mm <= MAX_DIST - (counter*10)/58;
							NEXT_STATE := STANDBY;
						END IF;
						
					WHEN STANDBY =>
						
				
				STATE := NEXT_STATE;
				
				END CASE;
				
			END IF;
			
			IF(INIT_KEY = '0') THEN
			
				STATE := DISP_TRIGGER;
				counter := 0;
				TRIGGER <= '0';
				
			END IF;
						
		END PROCESS;
	
END;