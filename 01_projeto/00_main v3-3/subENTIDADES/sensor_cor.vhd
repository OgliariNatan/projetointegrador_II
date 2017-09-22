
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	SENSOR COR								
--														
-- 	AUTORES: 	JEFERSON PEDROSO
--						TARCIS BECHER

--		ABRIL DE 2017




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.all;



entity sensor_cor is
	
	port(		CLOCK_50 : IN  std_logic;
				ENABLE	: IN	std_logic;
				POWER_0	: OUT	std_logic;		-- GPIO S0
				POWER_1	: OUT	std_logic;		-- GPIO S1
				FILTER_2	: OUT	std_logic;		-- GPIO S2
				FILTER_3	: OUT	std_logic;		-- GPIO S3
				MOTOR		: OUT	std_logic;
				OUT_SENSOR	: IN	std_logic; 								-- GPIO out
				RB			: OUT	std_logic_vector (6 downto 0);    -- COR JA EM FORMATO 7SEG
				EL			: OUT	std_logic_vector (6 downto 0);  -- COR JA EM FORMATO 7SEG
				DU			: OUT	std_logic_vector (6 downto 0)    -- COR JA EM FORMATO 7SEG
	);
				--LEDS		: OUT	std_logic_vector (17 downto 0)    -- COR JA EM FORMATO 7SEG

end sensor_cor;




ARCHITECTURE HARDWARE of sensor_cor is

	SIGNAL 	CLOCK_500k     : STD_LOGIC	:= '0';	
	SIGNAL 	EN_MDCOR	     : STD_LOGIC	:= '0';										--signal p divid clock
	
	
	constant IDLE0			 	: integer := 0;
	constant IDLE			 	: integer := 1;
	constant MEDE_FILTRO_VERMELHO	: integer := 2;
	constant MEDE_FILTRO_AZUL		: integer := 3;
	constant MEDE_FILTRO_VERDE	: integer := 4;
	constant DECIDE_QUE_COR		: integer := 5;
	
		
	
	BEGIN
	
---------------------------------------------------DIVISOR DE CLOCK
	process(CLOCK_50)
	
		variable counter : INTEGER range 0 to 12500000 := 0;
		begin
			if RISING_EDGE(CLOCK_50) then
				if counter < 12500000 then
					counter := counter + 1;
				else
					counter := 0;
					EN_MDCOR <= NOT EN_MDCOR;
				end if;
			end if;
	end process;
-------------------------------------------------------------------

	
---------------------------------------------------DIVISOR DE CLOCK
	process(CLOCK_50)
	
		variable counter_500k : INTEGER range 0 to 99 := 0;
		begin
			if RISING_EDGE(CLOCK_50) then
				if counter_500k < 99 then
					counter_500k := counter_500k + 1;
				else
					counter_500k := 0;
					CLOCK_500k <= NOT CLOCK_500k;
				end if;
			end if;
	end process;
-------------------------------------------------------------------

			
	PROCESS(CLOCK_500k)
	
	
		variable state 		:	integer range 0 to 5:=0;
		variable next_state 	:	integer range 0 to 5:=0;
		variable freq_filtroR	: 	integer range 0 to 100000:= 0;
		variable freq_filtroB	: 	integer range 0 to 100000:= 0;
		variable freq_filtroG	: 	integer range 0 to 100000:= 0;
		variable periodo_filtroR	: 	integer range 0 to 100000:= 0;
		variable periodo_filtroB	: 	integer range 0 to 100000:= 0;
		variable periodo_filtroG	: 	integer range 0 to 100000:= 0;
		variable flag 			: 	integer range 0 to 1:= 1;
--		
--		variable timeout 		: 	integer range 0 to 100000:=0;
--		variable conv			: 	integer range 0 to 3000;
	
	
	
	BEGIN
		
		IF (RISING_EDGE(CLOCK_500k))THEN
		
			IF(ENABLE = '1')THEN
				
				POWER_0 <= '1';     						-- power on
				POWER_1 <= '0';     						-- power on
				
				CASE state IS
				
					
					WHEN IDLE0 =>  							-- ESTADO DE REPOUSO
						IF(EN_MDCOR = '0') THEN
							next_state := IDLE;
							FILTER_2 <= '0';     						-- filtro
							FILTER_3 <= '0';     						-- vermelho
							freq_filtroR := 0;
							freq_filtroB := 0;
							freq_filtroG := 0;
						END IF;
					
					WHEN IDLE =>  							-- ESTADO DE REPOUSO
						IF(EN_MDCOR = '1') THEN
							next_state := MEDE_FILTRO_VERMELHO;
						END IF;
						
					WHEN MEDE_FILTRO_VERMELHO =>  							-- mede cor com filtro vermelho
					
						IF ((OUT_SENSOR = '1') AND (flag = 1)) THEN
							freq_filtroR := freq_filtroR + 1;
							flag := 0;
						END IF;
						IF (OUT_SENSOR = '0') then
							flag := 1;
						END IF;
						IF(EN_MDCOR = '0') THEN
							next_state := MEDE_FILTRO_AZUL;
							FILTER_2 <= '0';     						-- filtro
							FILTER_3 <= '1';     						-- azul
						END IF;
					
					
					WHEN MEDE_FILTRO_AZUL =>								-- mede cor com filtro azul				
						IF ((OUT_SENSOR = '1') AND (flag = 1)) THEN
							freq_filtroB := freq_filtroB + 1;
							flag := 0;
						END IF;
						IF (OUT_SENSOR = '0') then
							flag := 1;
						END IF;
						IF(EN_MDCOR = '1') THEN
							next_state := MEDE_FILTRO_VERDE;
							FILTER_2 <= '1';     						-- filtro
							FILTER_3 <= '1';     						-- verde
						END IF;
			
					WHEN MEDE_FILTRO_VERDE =>  							-- mede cor com filtro verde
						
						IF ((OUT_SENSOR = '1') AND (flag = 1)) THEN
							freq_filtroG := freq_filtroG + 1;
							flag := 0;
						END IF;
						IF (OUT_SENSOR = '0')then
							flag := 1;
						END IF;
						IF(EN_MDCOR = '0') THEN
							next_state := DECIDE_QUE_COR;
							
						END IF;
					
					WHEN DECIDE_QUE_COR =>
					
						-- a logica trabalha com a metade do *periodo das medidas em us, 
						-- então precisa-se converter o valores medidos de frequencia em Hz.
						-- freq é dado em (1000000/((frequencia/4)*4)/2);
						periodo_filtroR := (1000000/((freq_filtroR)*4))/2;
						periodo_filtroB := (1000000/((freq_filtroB)*4))/2;
						periodo_filtroG := (1000000/((freq_filtroG)*4))/2;
						
						--LEDS <= conv_std_logic_vector()
						
						IF((periodo_filtroR < periodo_filtroB) AND (periodo_filtroR < periodo_filtroG) AND (periodo_filtroR < 100))THEN
							-- então é vermelho
							
							RB <= "0101111";
							EL <= "0000100";
							DU <= "0100001";
								MOTOR <= '1';
							
							
								
						ELSE 
							IF((periodo_filtroR > periodo_filtroB) AND (periodo_filtroB < periodo_filtroG))THEN
								-- então é azul	
								
								RB <= "0000011";
								EL <= "1100111";
								DU <= "1100011";
								MOTOR <= '0';
								
							ELSE 
																									
								RB <= "0101111";
								EL <= "0000100";
								DU <= "0100001";
								MOTOR <= '1';
									
							END IF;
						END IF;
						next_state := IDLE0;
							
				END CASE;
				
				state := next_state;
				
			END IF;
			
			IF (ENABLE = '0') THEN
				state := IDLE0;
				POWER_0 <= '0';
				
			END IF;
			
		END IF;	
	END PROCESS;
END ARCHITECTURE;
