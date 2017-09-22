
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	DIVISOR DE CLOCK PARA SENSOR HCSR04
--														
-- 	AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		ABRIL DE 2017




LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY u_som IS
	GENERIC (n: POSITIVE := 8);
	PORT (
		CLOCK_IN:	IN BIT;
		RST:			IN STD_LOGIC; 
		ECHO:			IN STD_LOGIC;
		TRIGGER:		OUT STD_LOGIC;
		BCD:			OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END;




ARCHITECTURE HARDWARE OF u_som IS
	SIGNAL clock:		STD_LOGIC;
	SIGNAL trigg:		STD_LOGIC;										
	SIGNAL delay:		STD_LOGIC;										
	SIGNAL en_trigg:	STD_LOGIC;										
	SIGNAL en_delay:	STD_LOGIC;										
	SIGNAL rst_echo:	STD_LOGIC;											
	SIGNAL cont_pulse:STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	
	
	
	
BEGIN
	
	CLOCK_DIVIDE: WORK.divideclock
		GENERIC MAP(50000000,17000) 										
		PORT MAP(CLOCK_IN,clock); 											
		
	FSM: WORK.fsm_u_som
		PORT MAP(clock,RST,ECHO,trigg,delay,en_trigg,rst_echo,en_delay); 
	
	
	CONTADOR: WORK.cont_pulse
		GENERIC MAP(n) 
		PORT MAP(clock,rst_echo,ECHO,cont_pulse); 
		
		
	DECODE_DELAY: WORK.delay
		GENERIC MAP(8500) 
		PORT MAP(clock,en_delay,delay); 
		
	
	DECODE_TRIGG: WORK.trigger
		GENERIC MAP(1) 
		PORT MAP(clock,en_trigg,trigg); 
		
		
	CLASSIFICA: WORK.classificador
		PORT MAP(cont_pulse, BCD); 
		
	
TRIGGER <= trigg;	
END;

