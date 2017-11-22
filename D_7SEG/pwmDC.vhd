library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pwmDC is
	
	port(
		clk_50Mhz 	:in std_logic;			-- 50MHz input clock
		rst 		 	:in std_logic;			-- input clock
		sen_prox		:in std_logic;			-- Sensor de presença
		
		velocidade 	:out std_logic_vector(3 downto 0); --seleciona a velocidade do motor
			
		onOFF 		:in std_logic 				--define liga/desliga
		
	);
end entity pwmDC;


ARCHITECTURE behavior OF pwmDC IS


BEGIN

		
	
	
	


END behavior;