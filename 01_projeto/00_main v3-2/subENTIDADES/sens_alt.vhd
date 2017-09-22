
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	DECODER 7SEGMENTOS								
--														
-- 	AUTORES: 	JEFERSON PEDROSO
--						TARCIS BECHER

--		ABRIL DE 2017




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;



entity sens_alt is
	generic(	freqIn  	: INTEGER := 50000000;
				freqOut 	: INTEGER := 17000);						-- 17K VALOR DA FREQ DIVIDIDA
	
	port(		CLOCK_50 : IN  std_logic;
				ECHO		: IN	std_logic;
				MOTOR		: OUT std_logic;
				TRIG		: BUFFER	std_logic;
				VALOR		: OUT	std_logic_vector (7 downto 0)
	);

end sens_alt;




ARCHITECTURE HARDWARE of sens_alt is

	SIGNAL 	CLOCK     : STD_LOGIC	:= '0';										--signal p divid clock
	CONSTANT COUNT_MAX : INTEGER 		:= ((freqIn / freqOut) / 2) - 1;
	
	
	constant DISP_TRIG	 	: integer := 0;
	constant ESP_ECHO 		: integer := 1;
	constant MEDE_ECHO		: integer := 2;
	constant DELAY 			: integer := 3;
	
		
	
	BEGIN
	
---------------------------------------------------DIVISOR DE CLOCK
	process(CLOCK_50)
	
		variable counter : INTEGER range 0 to COUNT_MAX := 0;
		begin
			if RISING_EDGE(CLOCK_50) then
				if counter < COUNT_MAX then
					counter := counter + 1;
				else
					counter := 0;
					CLOCK <= NOT CLOCK;
				end if;
			end if;
	end process;
-------------------------------------------------------------------

	
	

			
	PROCESS(CLOCK, ECHO)
	
	
		variable state 		:	integer range 0 to 3:=0;
		variable next_state 	:	integer range 0 to 3:=0;
		variable count			: 	integer range 0 to 2000:= 0;
		variable hold 			: 	integer range 0 to 20001:=0;
--		variable timeout 		: 	integer range 0 to 100000:=0;
--		variable conv			: 	integer range 0 to 3000;
		
		VARIABLE PULSE 		: 	STD_LOGIC_VECTOR (7 DOWNTO 0):=(OTHERS => '0');
	
	
	
	BEGIN
		
		
		IF(RISING_EDGE(CLOCK))THEN 

			CASE state IS
			
				
				WHEN DISP_TRIG =>  							-- DA UM PULSO DE 10us NO TRIGGER
					trig  <= '1';
					count := count + 1;
					IF(count = 10) THEN
						count := 0;
						trig  <= '0';
						next_state := ESP_ECHO;
					END IF;
				
				
				WHEN ESP_ECHO =>								--FICA PRESO ENQUANTO ECHO=0
					IF (ECHO='1') THEN
						PULSE:= (OTHERS => '0');
						next_state := MEDE_ECHO;
					ELSE
						next_state := ESP_ECHO;
					END IF;
				
				
				WHEN MEDE_ECHO =>
					IF (ECHO='1') THEN
						PULSE:= PULSE+1;
					ELSE
						next_state := DELAY;
					END IF;
		
					
				WHEN DELAY =>
					hold := hold + 1;
					IF(hold > 17000) THEN
						hold := 0;
						next_state := DISP_TRIG;
					END IF;

						
			END CASE;
			
			state := next_state;

		END IF;
		
		VALOR <= (20-PULSE);  --ALTURA CORREÇÃO
		IF ((20-PULSE) > 8) THEN
			MOTOR <= '1';
		ELSE
			MOTOR <= '0';
		END IF;
		
	END PROCESS;
END ARCHITECTURE;
