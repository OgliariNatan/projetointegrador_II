
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


	BEGIN
		
		PROCESS(CLOCK_50)
			
			BEGIN
			
			IF(SW(0) = '1') THEN
				LEDG(0) <= '1';
				GPIO(0) <= '1';
			ELSE
				LEDG(0) <= '0';
				GPIO(0) <= '0';
			END IF;	
			
		END PROCESS;

END;
