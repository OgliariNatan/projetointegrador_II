
LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY debouncer_pi IS
	GENERIC(	freqIn		:		INTEGER := 50000000;
				delay			:		INTEGER := 100;
				defaultState:		STD_LOGIC := '0'
	);	
	PORT(	clockIn			: IN 	STD_LOGIC;
			buttonIn			: IN 	STD_LOGIC;
			buttonOut		: OUT STD_LOGIC
	);
END;



ARCHITECTURE behavior OF debouncer_pi IS


	SIGNAL buttonAux		: STD_LOGIC := '0';
	SIGNAL buttonPressed	: STD_LOGIC := '0';
	CONSTANT CONT_MAX		: INTEGER 	:= ((freqIn/ 1000) * delay) - 1;

	
	BEGIN
		buttonAux <= buttonIn WHEN defaultState = '0' ELSE (NOT buttonIn);
		
		
		PROCESS(clockIn)
		
			VARIABLE counter : INTEGER RANGE 0 TO CONT_MAX := 0;


			BEGIN
				IF RISING_EDGE(clockIn) THEN
					IF buttonPressed = '0' AND buttonAux = '1' THEN		-- Primeira vez pressionado
						buttonPressed <= '1';
						counter := 0;
					ELSIF buttonPressed = '1' AND buttonAux = '1' THEN	-- Ainda pressionado
						counter := 0;
					ELSIF buttonPressed = '1' AND buttonAux = '0' THEN	-- Bot�o � liberado ou uma trepida��o ocorreu
						IF counter < CONT_MAX THEN
							counter := counter + 1;
						ELSE
							counter := 0;
							buttonPressed <= '0';
						END IF;
					END IF;
				END IF;
		END PROCESS;
		buttonOut <= buttonPressed WHEN defaultState = '0' ELSE (NOT buttonPressed);

	END;