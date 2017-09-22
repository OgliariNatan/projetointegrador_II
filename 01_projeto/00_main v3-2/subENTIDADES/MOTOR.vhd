
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



entity MOTOR is
	
	port(		CLOCK_50 : IN  std_logic;
				SELETOR	: IN	std_logic_vector (2 downto 0);
				MOTOR		: IN	std_logic;		-- 
				MOTOR2	: IN 	std_logic;		-- 
				LADO		: OUT	std_logic		-- 
			--	MOTORP0		: out std_logic;
			--	MOTORP1		: out std_logic;
				--MOTORP2		: out std_logic;
				--MOTORP3		: out std_logic;
				--COMUM		: out std_logic;
	);

end MOTOR;



ARCHITECTURE HARDWARE of MOTOR is

		--constant PASSO_0	 	: integer := 0;
		--constant PASSO_1 		: integer := 1;
		--constant PASSO_2		: integer := 2;
		--constant PASSO_3 		: integer := 3;
		--SIGNAL MOT: STD_LOGIC;
		--SIGNAL CLOCK_1: STD_LOGIC;
	BEGIN
	
	--COMUM <= '1';
	
	--IF (SELETOR(0) = '1') THEN
	--	MOT <= MOTOR2;
	--ELSE
	--	MOT <= MOTOR;
	--END IF;
	
	--LADO <= MOT;
	
---------------------------------------------------DIVISOR DE CLOCK
--	process(CLOCK_50)
--
--		variable counter : INTEGER range 0 to 25000000 := 0;
--		begin
--			if RISING_EDGE(CLOCK_50) then
--				if counter < 25000000 then
--					counter := counter + 1;
--				else
--					counter := 0;
--					CLOCK_1 <= NOT CLOCK_1;
--				end if;
--			end if;
---	end process;
-------------------------------------------------------------------

	

	--Process(CLOCK_1)
	--	variable state 		:	integer range 0 to 3:=0;
	--	variable next_state 	:	integer range 0 to 3:=0;
	--	begin
	--	IF(RISING_EDGE(CLOCK_1))THEN 
--
--			CASE state IS
--			
	--			
		--		WHEN PASSO_0 =>  							-- DA UM PULSO DE 10us NO TRIGGER
		--			
		--			MOTORP0 <= '0';
		--			MOTORP1 <= '0';
	--				MOTORP2 <= '1';
	--				MOTORP3 <= '1';
	--			
	--			
	--			WHEN PASSO_1 =>								--FICA PRESO ENQUANTO ECHO=0
	--				
	--				MOTORP0 <= '1';
	--				MOTORP1 <= '0';
	--				MOTORP2 <= '0';
	--				MOTORP3 <= '1';
	--			
	--			
	--			WHEN PASSO_2 =>
	--				
	--				MOTORP0 <= '1';
	--				MOTORP1 <= '1';
	--				MOTORP2 <= '0';
	--				MOTORP3 <= '0';
	--	
	--				
	--			WHEN PASSO_3 =>
	---				
		--			MOTORP0 <= '0';
		--			MOTORP1 <= '0';
		--			MOTORP2 <= '0';
		--			MOTORP3 <= '0';
--
--						
--			END CASE;
--			
--			state := next_state;
--
	--	END IF;
		
--	end process;
END ARCHITECTURE;
