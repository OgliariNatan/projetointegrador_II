
LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY teste_trigger IS

	PORT(	CLOCK_50			: IN 	STD_LOGIC;
			SW					: IN 	STD_LOGIC_VECTOR (3 DOWNTO 0);
			GPIO				: OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
			LEDG				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	
END;


ARCHITECTURE behavior OF teste_trigger IS

	CONSTANT COUNT_MAX	: INTEGER 	:= 500;
	SIGNAL	EN_TRIG		: STD_LOGIC	:= '0';

	BEGIN
		
	PROCESS(CLOCK_50)
		
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX := 0;

		
		BEGIN
		
		IF(SW(0) = '1') THEN
			EN_TRIG <= '1';
			
		ELSE
			EN_TRIG <= '0';
			
		END IF;
		
		
		IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
			IF(EN_TRIG = '1') THEN
				IF counter < COUNT_MAX THEN
					counter := counter + 1;
					GPIO(0) <= '1';
				ELSE
					counter := 0;
					GPIO(0) <= '0';
					EN_TRIG <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;
END;


