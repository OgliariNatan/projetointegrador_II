-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;
-----------------------------------------
ENTITY Esteira_PI IS
	PORT ( KEY  	:  IN 	STD_LOGIC_VECTOR (3 DOWNTO 0);
		   CLOCK_50 :  IN 	STD_LOGIC;
		   LCD_DATA	:  OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
		   LCD_EN	:  OUT	STD_LOGIC;
		   LCD_RW	:  buffer	STD_LOGIC;
		   LCD_RS	:  OUT	STD_LOGIC;
		   LCD_ON	:  OUT	STD_LOGIC;
		   LCD_BLON	:  OUT	STD_LOGIC
		 );
END Esteira_PI;
----------------------------------------
ARCHITECTURE object_picker OF Esteira_PI IS
	SIGNAL clock_100: STD_LOGIC;
			
		SIGNAL lcd_state	:INTEGER RANGE 0 TO 5 := 1;
		SIGNAL cor_e		:INTEGER RANGE 0 TO 2 := 2;
		SIGNAL altura_e	:INTEGER RANGE 0 TO 999 := 250;
		SIGNAL altura_ce	:INTEGER RANGE 0 TO 60;
		SIGNAL altura_de	:INTEGER RANGE 0 TO 60;
		SIGNAL altura_ue	:INTEGER RANGE 0 TO 60;
		SIGNAL peso_e		:INTEGER RANGE 0 TO 999 := 250;
		SIGNAL peso_ce		:INTEGER RANGE 0 TO 60;
		SIGNAL peso_de		:INTEGER RANGE 0 TO 60;
		SIGNAL peso_ue		:INTEGER RANGE 0 TO 60;
		SIGNAL altura_e	:INTEGER RANGE 0 TO 999 := 150;
		SIGNAL altura_ce	:INTEGER RANGE 0 TO 60;
		SIGNAL altura_de	:INTEGER RANGE 0 TO 60;
		SIGNAL altura_ue	:INTEGER RANGE 0 TO 60;
		SIGNAL peso_e		:INTEGER RANGE 0 TO 999 := 150;
		SIGNAL peso_ce		:INTEGER RANGE 0 TO 60;
		SIGNAL peso_de		:INTEGER RANGE 0 TO 60;
		SIGNAL peso_ue		:INTEGER RANGE 0 TO 60;
		
	BEGIN
	
	altura_ce <= ((altura_e/100) + 48);
	altura_de <= (((altura_e/10) - ((altura_e/100)*10)) + 48);
	altura_ue <= ((altura_e rem 10) + 48);
		
	peso_ce <= ((peso_e/100) + 48);
	peso_de <= (((peso_e/10) - ((peso_e/100)*10)) + 48);
	peso_ue <= ((peso_e rem 10) + 48);	
		
	LCD_ON	<=		'1';
	LCD_BLON	<=		'1';
	
	
		PROCESS (CLOCK_50)
		variable count100us  :  INTEGER RANGE 0 TO 5000;

		BEGIN
		
			IF (rising_edge(CLOCK_50)) THEN
				count100us := count100us + 1;
				IF (count100us = 2500) THEN			--2500
					clock_100 <= NOT clock_100;
					count100us := 0;
				END IF;
			END IF;
		END PROCESS;
	
	
---------------------------------------------------------------------------------------
-------------------------- MAQUINA DE ESTADOS LCD --------------------------------------
		lcd_process : PROCESS
		VARIABLE auxtemp	:	INTEGER RANGE 0 TO 2000;
		VARIABLE auxcount	:	INTEGER RANGE 0 TO 1;
		VARIABLE test		:	INTEGER RANGE 0 TO 2000 :=0;
		BEGIN
						
			wait until rising_edge(clock_100);
	
			IF (auxcount=1) THEN
				auxtemp := auxtemp + 1;
			END IF;
			
			
			
		CASE lcd_state IS
			WHEN 0 => 										-- Case 0 = idle
				auxtemp := 0;								-- Case 1 = Init
				auxcount:=0;								-- Case 3 = Cor
				LCD_DATA <= "00000000";					--	
				LCD_RS	<=	'0';							--	
				LCD_RW	<=	'0';							--	
				LCD_EN 	<= '0';							--
				lcd_state <= 0;							--
					
			WHEN 1 => 			
				CASE auxtemp IS								--Passo 1, 50ms----- Init
					WHEN 0 => 		LCD_DATA <= "00110000";							--
										LCD_RS	<=	'0';									--
										LCD_RW	<=	'0';									--
										LCD_EN 	<= '0';									--
										auxcount:=1;										--
										
					WHEN 1000 => 	LCD_EN	<= '1';									--
					WHEN 1001 => 	LCD_EN	<= '0';			--------------------
					
					WHEN 1100 => 	LCD_EN	<= '1';			--Passo 2, 5ms--------
					WHEN 1101 =>	LCD_EN	<= '0';			----------------------	

					WHEN 1103 =>	LCD_EN	<= '1';			--Passo 3, 100us---- Init
					WHEN 1104 =>	LCD_EN	<= '0';			--------------------			
			
					WHEN 1105 =>	LCD_DATA <= "00110000";	--Passo 4----------- Define 8bits lcd_DATA WHEN 1106 =>
										LCD_EN	<= '1';									--
					WHEN 1107 => 	LCD_EN	<= '0';									--
					
					WHEN 1108 =>	LCD_DATA <= "00111000";	--Passo 5----------- Define 2 line and character 5x8 WHEN 1109 =>
										LCD_EN	<= '1';									--
					WHEN 1110 => 	LCD_EN	<= '0';									--
					
					WHEN 1111 => 	LCD_DATA <= "00001000";	--Passo 6----------- Display off WHEN 1112 =>
										LCD_EN	<= '1';									--
					WHEN 1113 =>	LCD_EN	<= '0';									--
					
					WHEN 1114 =>	LCD_DATA <= "00000001";	--Passo 7----------- Clear display WHEN 1115 =>
										LCD_EN	<= '1';									--
					WHEN 1116 => 	LCD_EN	<= '0';									--
					
					WHEN 1217 =>	LCD_DATA <= "00000110";	--Passo 8----------- Entry set mode WHEN 1218 =>
										LCD_EN	<= '1';									--
					WHEN 1219 =>	LCD_EN	<= '0';									--
					
					WHEN 1220 =>	LCD_DATA <= "00001100";	--Passo 9----------- Display on WHEN 1221 =>
										LCD_EN	<= '1';									--
					WHEN 1222 =>	auxtemp := 0;
										auxcount:=0;
										LCD_DATA <= "00000000";							
										LCD_RS	<=	'0';									
										LCD_RW	<=	'0';									
										LCD_EN 	<= '0';
										lcd_state <= 2;			--------------------
					
					WHEN OTHERS 	=> NULL;
				END CASE;								
			
			WHEN 2 => 
				CASE auxtemp IS											--Clear Display
				
					WHEN 0 =>	LCD_DATA <= X"D4";					--	X"80" 1line
									auxcount:=1;							--	X"C0" 2line
									LCD_RS	<=	'0';						--	X"94" 3line
									LCD_RW	<=	'0';						--	X"D4" 4line
									LCD_EN 	<= '1';
					WHEN 1 =>	LCD_EN 	<= '0';
				
				
				--	WHEN 0 =>	LCD_DATA <= "00000001";								
				--					auxcount:=1;
				--					LCD_RS	<=	'0';									
				--					LCD_RW	<=	'0';									
				--					LCD_EN 	<= '1';
				--	WHEN 1 =>	LCD_EN 	<= '0';
					
					WHEN 101 =>	LCD_DATA <= X"43";								-- test, imprime letra C
									LCD_RS	<=	'1';
									LCD_EN 	<= '1';
					WHEN 102 =>	LCD_EN 	<= '0';
					
					WHEN 103 =>	LCD_DATA <= X"6F";								-- test, imprime letra o
									LCD_EN	<= '1';
					WHEN 104 =>	LCD_EN	<= '0';									--
					
					WHEN 105 =>	LCD_DATA <= X"72";								-- test, imprime letra r
									LCD_EN	<= '1';
					WHEN 106 =>	LCD_EN	<= '0';									--
					
					WHEN 107 =>	LCD_DATA <= X"3A";								-- test, imprime letra :
									LCD_EN	<= '1';
					WHEN 108 =>	LCD_EN	<= '0';									--
					
					WHEN 109 =>	LCD_DATA <= X"20";								-- test, imprime espaço
									LCD_EN	<= '1';
					WHEN 110 =>	LCD_EN	<= '0';									--
									

					WHEN OTHERS => 
						CASE cor_e IS
							WHEN 0 => 
								CASE auxtemp IS
									WHEN 112 =>	LCD_DATA <= X"56";								-- test, imprime letra V
													LCD_EN 	<= '1';
									WHEN 113 =>	LCD_EN 	<= '0';
									
									WHEN 114 =>	LCD_DATA <= X"65";								-- test, imprime letra e
													LCD_EN	<= '1';
									WHEN 115 =>	LCD_EN	<= '0';									--
									
									WHEN 116 =>	LCD_DATA <= X"72";								-- test, imprime letra r
													LCD_EN	<= '1';
									WHEN 117 =>	LCD_EN	<= '0';									--
								
									WHEN 118 =>	LCD_DATA <= X"6D";								-- test, imprime letra m
													LCD_EN	<= '1';
									WHEN 119 =>	LCD_EN	<= '0';									--

									WHEN 120 =>	LCD_DATA <= X"65";								-- test, imprime letra e
													LCD_EN	<= '1';
									WHEN 121 =>	LCD_EN	<= '0';									--
								
									WHEN 122 =>	LCD_DATA <= X"6C";								-- test, imprime letra l
													LCD_EN	<= '1';
									WHEN 123 =>	LCD_EN	<= '0';									--
									
									WHEN 124 =>	LCD_DATA <= X"68";								-- test, imprime letra h
													LCD_EN	<= '1';
									WHEN 125 =>	LCD_EN	<= '0';									--
									
									WHEN 126 =>	LCD_DATA <= X"6F";								-- test, imprime letra o
													LCD_EN	<= '1';
									WHEN 127 =>	LCD_EN	<= '0';									--
													lcd_state<=  0 ;
									WHEN OTHERS => NULL;
								END CASE;
							
							WHEN 1 => 
								CASE auxtemp IS
									WHEN 112 =>	LCD_DATA <= X"56";								-- test, imprime letra V
													LCD_RS	<=	'1';
													LCD_EN 	<= '1';
									WHEN 113 =>	LCD_EN 	<= '0';
									
									WHEN 114 =>	LCD_DATA <= X"65";								-- test, imprime letra e
													LCD_EN	<= '1';
									WHEN 115 =>	LCD_EN	<= '0';									--
									
									WHEN 116 =>	LCD_DATA <= X"72";								-- test, imprime letra r
													LCD_EN	<= '1';
									WHEN 117 =>	LCD_EN	<= '0';									--
								
									WHEN 118 =>	LCD_DATA <= X"64";								-- test, imprime letra d
													LCD_EN	<= '1';
									WHEN 119 =>	LCD_EN	<= '0';									--

									WHEN 120 =>	LCD_DATA <= X"65";								-- test, imprime letra e
													LCD_EN	<= '1';
									WHEN 121 =>	LCD_EN	<= '0';									--
													lcd_state<=  0 ;
									WHEN OTHERS => NULL;
								END CASE;
							
							WHEN 2 => 
								CASE auxtemp IS
									WHEN 112 =>	LCD_DATA <= X"41";								-- test, imprime letra A
													LCD_RS	<=	'1';
													LCD_EN 	<= '1';
									WHEN 113 =>	LCD_EN 	<= '0';
									
									WHEN 114 =>	LCD_DATA <= X"7A";								-- test, imprime letra z
													LCD_EN	<= '1';
									WHEN 115 =>	LCD_EN	<= '0';									--
									
									WHEN 116 =>	LCD_DATA <= X"75";								-- test, imprime letra u
													LCD_EN	<= '1';
									WHEN 117 =>	LCD_EN	<= '0';									--
								
									WHEN 118 =>	LCD_DATA <= X"6C";								-- test, imprime letra l
													LCD_EN	<= '1';
									WHEN 119 =>	LCD_EN	<= '0';									--
													lcd_state<=  0 ;
									WHEN OTHERS => NULL;
								END CASE;
							WHEN OTHERS => lcd_state <= 0;
						END CASE;
				END CASE;
				
			WHEN 3 =>
				CASE auxtemp IS														--Clear Display
					WHEN 0 =>	LCD_DATA <= "00000001";								
									auxcount:=1;
									LCD_RS	<=	'0';									
									LCD_RW	<=	'0';									
									LCD_EN 	<= '1';
					WHEN 1 =>	LCD_EN 	<= '0';
					
					WHEN 101 =>	LCD_DATA <= X"41";								-- imprime letra A
									LCD_RS	<=	'1';
									LCD_EN 	<= '1';
					WHEN 102 =>	LCD_EN 	<= '0';
					
					WHEN 103 =>	LCD_DATA <= X"6C";								-- imprime letra l
									LCD_EN	<= '1';
					WHEN 104 =>	LCD_EN	<= '0';									--

					WHEN 105 =>	LCD_DATA <= X"74";								-- imprime letra t
									LCD_EN	<= '1';
					WHEN 106 =>	LCD_EN	<= '0';									--
					
					WHEN 107 =>	LCD_DATA <= X"75";								-- imprime letra u
									LCD_EN	<= '1';
					WHEN 108 =>	LCD_EN	<= '0';									--
					
					WHEN 109 =>	LCD_DATA <= X"72";								-- imprime letra r
									LCD_EN	<= '1';
					WHEN 110 =>	LCD_EN	<= '0';									--
					
					WHEN 111 =>	LCD_DATA <= X"61";								-- imprime letra a
									LCD_EN	<= '1';
					WHEN 112 =>	LCD_EN	<= '0';									--
					
					WHEN 113 =>	LCD_DATA <= X"3A";								-- imprime letra :
									LCD_EN	<= '1';
					WHEN 114 =>	LCD_EN	<= '0';									--
					
					WHEN 115 =>	LCD_DATA <= X"20";								-- imprime espaço
									LCD_EN	<= '1';
					WHEN 116 =>	LCD_EN	<= '0';
					
					WHEN 117 =>	LCD_DATA <= std_logic_vector(to_unsigned(altura_ce, LCD_DATA'length));								-- imprime letra r
									LCD_EN	<= '1';
					WHEN 118 =>	LCD_EN	<= '0';									--
					
					WHEN 119 =>	LCD_DATA <= std_logic_vector(to_unsigned(altura_de, LCD_DATA'length));								-- imprime letra a
									LCD_EN	<= '1';
					WHEN 120 =>	LCD_EN	<= '0';									--
					
					WHEN 121 =>	LCD_DATA <= std_logic_vector(to_unsigned(altura_ue, LCD_DATA'length));								-- imprime letra :
									LCD_EN	<= '1';
					WHEN 122 =>	LCD_EN	<= '0';									--
					
					WHEN OTHERS =>	NULL;		
				END CASE;
			
			WHEN 4 =>
				CASE auxtemp IS														--Clear Display
					WHEN 0 =>	LCD_DATA <= "00000001";								
									auxcount:=1;
									LCD_RS	<=	'0';									
									LCD_RW	<=	'0';									
									LCD_EN 	<= '1';
					WHEN 1 =>	LCD_EN 	<= '0';
					
					WHEN 101 =>	LCD_DATA <= X"50";								-- imprime letra P
									LCD_RS	<=	'1';
									LCD_EN 	<= '1';
					WHEN 102 =>	LCD_EN 	<= '0';
					
					WHEN 103 =>	LCD_DATA <= X"65";								-- imprime letra e
									LCD_EN	<= '1';
					WHEN 104 =>	LCD_EN	<= '0';									--

					WHEN 105 =>	LCD_DATA <= X"73";								-- imprime letra s
									LCD_EN	<= '1';
					WHEN 106 =>	LCD_EN	<= '0';									--
					
					WHEN 107 =>	LCD_DATA <= X"6F";								-- imprime letra o
									LCD_EN	<= '1';
					WHEN 108 =>	LCD_EN	<= '0';									--
					
					WHEN 113 =>	LCD_DATA <= X"3A";								-- imprime letra :
									LCD_EN	<= '1';
					WHEN 114 =>	LCD_EN	<= '0';									--
					
					WHEN 115 =>	LCD_DATA <= X"20";								-- imprime espaço
									LCD_EN	<= '1';
					WHEN 116 =>	LCD_EN	<= '0';
					
					WHEN 117 =>	LCD_DATA <= std_logic_vector(to_unsigned(peso_ce, LCD_DATA'length));								-- imprime letra r
									LCD_EN	<= '1';
					WHEN 118 =>	LCD_EN	<= '0';									--
					
					WHEN 119 =>	LCD_DATA <= std_logic_vector(to_unsigned(peso_de, LCD_DATA'length));								-- imprime letra a
									LCD_EN	<= '1';
					WHEN 120 =>	LCD_EN	<= '0';									--
					
					WHEN 121 =>	LCD_DATA <= std_logic_vector(to_unsigned(peso_ue, LCD_DATA'length));								-- imprime letra :
									LCD_EN	<= '1';
					WHEN 122 =>	LCD_EN	<= '0';									--
					
					WHEN OTHERS =>	NULL;		
				END CASE;	
				
			WHEN OTHERS 	=> lcd_state <= 0;
		END CASE;
	END PROCESS lcd_process;
--------------------------------------------------------------------------------------

END object_picker;
