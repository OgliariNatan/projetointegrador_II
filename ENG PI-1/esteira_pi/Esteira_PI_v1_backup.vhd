-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-----------------------------------------
ENTITY Esteira_PI IS
	PORT ( KEY  	:  IN 	STD_LOGIC_VECTOR (3 DOWNTO 0);
		   CLOCK_50 :  IN 	STD_LOGIC;
		   LCD_DATA	:  OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
		   LCD_EN	:  OUT	STD_LOGIC;
		   LCD_RW	:  OUT	STD_LOGIC;
		   LCD_RS	:  OUT	STD_LOGIC;
		   LCD_ON	:  OUT	STD_LOGIC;
		   LCD_BLON	:  OUT	STD_LOGIC
		 );
END Esteira_PI;
----------------------------------------
ARCHITECTURE object_picker OF Esteira_PI IS
	SIGNAL clock_100: STD_LOGIC;
	
	TYPE lcd_states IS 
	(idle, init);
		
		signal lcd_state : lcd_states := init;

	BEGIN

	LCD_ON	<=		'1';
	LCD_BLON	<=		'1';
	
	
		PROCESS (CLOCK_50)
		variable count100us  :  INTEGER RANGE 0 TO 5000;
		
		BEGIN
			
			IF (rising_edge(CLOCK_50)) THEN
				count100us := count100us + 1;
				IF (count100us = 1) THEN			--250
					clock_100 <= NOT clock_100;
					count100us := 0;
				END IF;
			END IF;
		END PROCESS;
	
	
---------------------------------------------------------------------------------------
-------------------------- MAQUINA DE ESTADOS LCD --------------------------------------
		PROCESS (clock_100)
		VARIABLE auxtemp	:	INTEGER RANGE 0 TO 2000;
		BEGIN
			CASE lcd_state IS
			WHEN idle => 
				auxtemp := 0;
				LCD_DATA <= "00000000";							
				LCD_RS	<=	'0';									
				LCD_RW	<=	'0';									
				LCD_EN 	<= '0';	
					
			WHEN init => 
				IF (rising_edge(clock_100)) THEN
					auxtemp := auxtemp + 1;
						
					IF (auxtemp = 1) THEN		--Passo 1, 40ms----- Init
						LCD_DATA <= "00000000";							--
						LCD_RS	<=	'0';									--
						LCD_RW	<=	'0';									--
						LCD_EN 	<= '0';									--
					END IF;													--
																				--
					IF (auxtemp = 1000) THEN							--
						LCD_EN	<= '1';									--
					END IF;													--
																				--
					IF (auxtemp = 1001) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------
					
					IF (auxtemp = 1101) THEN	--Passo 2, 5ms------ Init
						LCD_EN	<= '1';									--
					END IF;													--
																				--
					IF (auxtemp = 1102) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------	

					IF (auxtemp = 1103) THEN	--Passo 3, 100us---- Init
						LCD_EN	<= '1';									--
					END IF;													--
																				--
					IF (auxtemp = 1104) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------			
			
					IF (auxtemp = 1105) THEN	--Passo 4----------- Define 8bits lcd_DATA
						LCD_DATA <= "00110000";							--
					END IF;													--
																				--
					IF (auxtemp = 1106) THEN							--
						LCD_EN	<= '1';									--
					END IF;							 						--	
																				--
					IF (auxtemp = 1107) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------	
					
					IF (auxtemp = 1108) THEN	--Passo 5----------- Define 2 line and character 5x8
						LCD_DATA <= "00111000";							--
					END IF;													--
																				--
					IF (auxtemp = 1109) THEN							--
						LCD_EN	<= '1';									--
					END IF;							 						--	
																				--
					IF (auxtemp = 1110) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------

					IF (auxtemp = 1111) THEN	--Passo 6----------- Display off
						LCD_DATA <= "00001000";							--
					END IF;													--
																				--
					IF (auxtemp = 1111) THEN							--
						LCD_EN	<= '1';									--
					END IF;							 						--	
																				--
					IF (auxtemp = 1113) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------		

					IF (auxtemp = 1114) THEN	--Passo 7----------- Clear display
						LCD_DATA <= "00000001";							--
					END IF;													--
																				--
					IF (auxtemp = 1115) THEN							--
						LCD_EN	<= '1';									--
					END IF;							 						--	
																				--
					IF (auxtemp = 1116) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------			

					IF (auxtemp = 1117) THEN	--Passo 8----------- Entry set mode  ???????
						LCD_DATA <= "00000110";							--
					END IF;													--
																				--
					IF (auxtemp = 1118) THEN							--
						LCD_EN	<= '1';									--
					END IF;							 						--	
																				--
					IF (auxtemp = 1119) THEN							--
						LCD_EN	<= '0';									--
					END IF;							--------------------	
					
					IF (auxtemp = 1120) THEN	--Passo 9----------- Display on
						LCD_DATA <= "00001100";							--
					END IF;													--
																				--
					IF (auxtemp = 1121) THEN							--
						LCD_EN	<= '1';									--
					END IF;							 						--	
																				--
					IF (auxtemp = 1122) THEN							--
						LCD_EN	<= '0';									--
						auxtemp := 0;
						lcd_state <= idle;
					END IF;							--------------------	
				END IF;
					
			END CASE;
		END PROCESS;
--------------------------------------------------------------------------------------

END object_picker;
