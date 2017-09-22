
--	INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	DIVISOR DE CLOCK PARA SENSOR HCSR04
--														
-- 	AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		ABRIL DE 2017





LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;




ENTITY classificador IS
	PORT( 
		CONT_PULSE:	IN		STD_LOGIC_VECTOR (7 DOWNTO 0);
		BCD:			OUT	STD_LOGIC_VECTOR (9 DOWNTO 0)
	);
END;




ARCHITECTURE HARDWARE OF classificador IS
	BEGIN
		PROCESS (CONT_PULSE)
		VARIABLE z: STD_LOGIC_VECTOR (17 DOWNTO 0);
		BEGIN
			for i in 0 to 17 loop
				z(i) := '0';
			end loop;
			
			z(10 downto 3) := CONT_PULSE;
			
			for i in 0 to 4 loop
				if z(11 downto 8) > 4 then
					z(11 downto 8) := z(11 downto 8) + 3;
				end if;
				
				if z(15 downto 12) >4 then
					z(15 downto 12):= z(15 downto 12) + 3;
				end if;
				
				z (17 downto 1) := z(16 downto 0);
			end loop;
			
			BCD <= z(17 downto 8);
			
		END PROCESS;
END;