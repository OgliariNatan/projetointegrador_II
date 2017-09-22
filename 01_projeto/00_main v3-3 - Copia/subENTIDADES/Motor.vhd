
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	MOTOR								
--														
-- 	AUTORES: 	JEFERSON PEDROSO
--						TARCIS BECHER

--		ABRIL DE 2017




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;



entity Motor is
	
	port(		CLOCK_50 : IN  std_logic;
				DIR		: IN	std_logic;
				MOT0		: OUT	std_logic;
				MOT1		: OUT	std_logic;
				MOT2		: OUT	std_logic;
				MOT3		: OUT	std_logic
	);

end Motor;




ARCHITECTURE HARDWARE of Motor is

	SIGNAL 	CLOCK_100     : STD_LOGIC	:= '0';
	
	constant PASSO_0			: integer := 0;
	constant PASSO_1			: integer := 1;
	constant PASSO_2			: integer := 2;
	constant PASSO_3			: integer := 3;
	
		
	
	BEGIN

	
---------------------------------------------------DIVISOR DE CLOCK
	process(CLOCK_50)
	
		variable counter_100 : INTEGER range 0 to 125000 := 0;
		begin
			if RISING_EDGE(CLOCK_50) then
				if counter_100 < 125000 then
					counter_100 := counter_100 + 1;
				else
					counter_100 := 0;
					CLOCK_100 <= NOT CLOCK_100;
				end if;
			end if;
	end process;
-------------------------------------------------------------------

			
	PROCESS(CLOCK_100)
	
	
		variable state 		:	integer range 0 to 3:=0;
		variable next_state 	:	integer range 0 to 3:=0;
		VARIABLE cont 			: 	integer range 0 to 500:=0;
		variable flag 			: 	integer range 0 to 1:= 1;
--		
--		variable timeout 		: 	integer range 0 to 100000:=0;
--		variable conv			: 	integer range 0 to 3000;
	
	
	
	BEGIN
		
		IF (RISING_EDGE(CLOCK_100))THEN
								
			CASE state IS
			
				WHEN PASSO_0 =>
				
				MOT0 <= '0';
				MOT1 <= '1';
				MOT2 <= '1';
				MOT3 <= '0';
				IF (cont < 500) THEN
				
					IF ((DIR = '0')) THEN
						
						cont := cont + 1;
						next_state := PASSO_1;
					END IF;
					
				END IF;
				
				IF (cont > 0) THEN
				
					IF ((DIR = '1')) THEN
						
						cont := cont - 1;
						next_state := PASSO_3;
					END IF;
					
				END IF;
				
										
				
				WHEN PASSO_1 =>  
				
				MOT0 <= '1';
				MOT1 <= '1';
				MOT2 <= '0';
				MOT3 <= '0';
				
				IF (cont < 500) THEN
				
					IF ((DIR = '0')) THEN
						
						cont := cont + 1;
						next_state := PASSO_2;
					END IF;
					
				END IF;
				
				IF (cont > 0) THEN
				
					IF ((DIR = '1')) THEN
						
						cont := cont - 1;
						next_state := PASSO_0;
					END IF;
					
				END IF;
				
				
					
				WHEN PASSO_2 => 
				
				MOT0 <= '1';
				MOT1 <= '0';
				MOT2 <= '0';
				MOT3 <= '1';
				
				IF (cont < 500) THEN
				
					IF ((DIR = '0')) THEN
						
						cont := cont + 1;
						next_state := PASSO_3;
					END IF;
					
				END IF;
				
				IF (cont > 0) THEN
				
					IF ((DIR = '1')) THEN
						
						cont := cont - 1;
						next_state := PASSO_1;
					END IF;
					
				END IF;
				
				
				WHEN PASSO_3 =>
				
				MOT0 <= '0';
				MOT1 <= '0';
				MOT2 <= '1';
				MOT3 <= '1';
				
				IF (cont < 500) THEN
				
					IF ((DIR = '0')) THEN
						
						cont := cont + 1;
						next_state := PASSO_0;
					END IF;
					
				END IF;
				
				IF (cont > 0) THEN
				
					IF ((DIR = '1')) THEN
						
						cont := cont - 1;
						next_state := PASSO_2;
					END IF;
					
				END IF;
				
			END CASE;
			
			state := next_state;
			
			
		END IF;	
	END PROCESS;
END ARCHITECTURE;
