LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


<<<<<<< HEAD
ENTITY teste_cor IS

	GENERIC
	( 
		freqIn			: INTEGER	:= 50000000;  	--Frequencia da placa
		defaultState	: STD_LOGIC := '0'; 			--Define dois estados "1" "0"
		freqOut 			: INTEGER	:= 100	 		--Saida do divisor de clock	
	);
	
	PORT
	(		--Definições dos sinais de entrada
			CLOCK_50			: IN STD_LOGIC;--Entrada do clock da placa
		
		
			-- Sensor de distância
			GPIO				: INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);	-- Declara os pinos GPIO como I/O
			--GPIO(1) = echo
			--GPIO(2) = Trigger	
	
			--Definições de botão de ajuste 
			  KEY				: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
			  SW				: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
=======
--teste 
>>>>>>> be0d8669a3db01a4ad9a929253f110bda338270b

			--Definição do display_7Segmentos
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: OUT STD_LOGIC_VECTOR (0 TO 6);

			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut		: BUFFER STD_LOGIC;
			
			--DECLARAÇÂO DE LED para testes
			LEDR				: OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDG				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
			  
END teste_cor;


ARCHITECTURE behavior OF teste_cor IS

	TYPE State_type IS (STANDBY, BLUE_CONFIG, RED_CONFIG, GREEN_CONFIG, READING);  -- Define os estados da maquina de estados
		
	SIGNAL	state 					: State_Type;    -- Variavel que recebe o proximo estado da maquina de estados
	SIGNAL	CLOCKOUT					: STD_LOGIC;
	SIGNAL   clock						: STD_LOGIC := '0';
	SIGNAL	timer 					: integer range 0 to 101;
	SIGNAL	timer_rst 				: std_logic;
	SIGNAL	timer_en 				: std_logic;
	SIGNAL	pulse_counter			: integer range 0 to 70000;
	SIGNAL   READ_PULSE				: STD_LOGIC := '0';
	SIGNAL   READ_OK					: STD_LOGIC := '0';
	SIGNAL 	selecao 					: INTEGER RANGE 0 TO 1:= 0; --Numero de seleção
	SIGNAL	color						: STD_LOGIC := '0';
	SIGNAL	dist_cm					: INTEGER range 0 to 511;
		
	CONSTANT COUNT_MAX				: INTEGER 	:= ((freqIn / freqOut) / 2)-1;

	BEGIN
		
	fsm_state: PROCESS(CLOCKOUT, SW(17)) --SW(17)=RST
	begin
		
		if SW(17) = '1' then 
			state <= STANDBY;
	
		elsif rising_edge(CLOCKOUT) then
		
			case state is
			
				when STANDBY 		=>
				
				if SW(15) = '1' then
				
					state <= BLUE_CONFIG;
					
				elsif SW(13) = '1' then
					
					state <= RED_CONFIG;
						
				elsif SW(11) = '1' then
					
					state <= GREEN_CONFIG;
					
				else 
				
					state <= STANDBY;
					
				end if;
				
				when BLUE_CONFIG	=>
					
					state <= READING;
				
				when RED_CONFIG	=>
				
					state <= READING;
				
				when GREEN_CONFIG	=>
			
					state <= READING;
				
				when READING		=> 
				
					if READ_OK = '0' then
					
						state <= READING;
					
					else
					
						state <= STANDBY;
						
					end if;
						
				when others 		=>
				
					state <= STANDBY;
				
			end case;	
			
		end if;
		
	end process;
	
	fsm_moore: process(state)
	begin
	
	timer_rst	<= '1';
	timer_en		<= '0';
	--reg_data_en <= '0';
	
		case state is
			
			when STANDBY 		=>
			
				GPIO(0) <= '1';			-- PINO S0 (SELECAO DE FREQ. = 100%)
				GPIO(1) <= '1';			-- PINO S1 (SELECAO DE FREQ. = 100%)
				GPIO(2) <= '1';			-- PINO S2 (SELECAO DO FILTRO DE COR - CLEAR)
				GPIO(3) <= '0';			-- PINO S3 (SELECAO DO FILTRO DE COR - CLEAR)
				GPIO(4) <= '1';			-- PINO S4 ( OUTPUT ENABLE LOW ACTIVE)
				
			when BLUE_CONFIG	=>
			
				GPIO(2) <= '0';			-- PINO S2 (SELECAO DO FILTRO DE COR - BLUE)
				GPIO(3) <= '1';			-- PINO S3 (SELECAO DO FILTRO DE COR - BLUE)
				GPIO(4) <= '0';			-- PINO S4 ( OUTPUT ENABLE LOW ACTIVE)
				timer_rst	<= '0';		--
				timer_en		<= '1';		--
				
			when RED_CONFIG	=>
			
				GPIO(2) <= '0';			-- PINO S2 (SELECAO DO FILTRO DE COR - RED)
				GPIO(3) <= '0';			-- PINO S3 (SELECAO DO FILTRO DE COR - RED)
				GPIO(4) <= '0';			-- PINO S4 ( OUTPUT ENABLE LOW ACTIVE)
				timer_rst	<= '0';		--
				timer_en		<= '1';		--
			
			when GREEN_CONFIG	=>
				
				GPIO(2) <= '1';			-- PINO S2 (SELECAO DO FILTRO DE COR - GREEN)
				GPIO(3) <= '1';			-- PINO S3 (SELECAO DO FILTRO DE COR - GREEN)
				GPIO(4) <= '0';			-- PINO S4 ( OUTPUT ENABLE LOW ACTIVE)
				timer_rst	<= '0';		--
				timer_en		<= '1';		--
				
			when READING 		=>
				
--				if rising_edge(CLOCKOUT) AND timer<100 AND GPIO(5) = '1' then
--				
--					pulse_counter	<=	pulse_counter + 1;
--					READ_PULSE		<=	'1';
--					
--				elsif falling_edge(CLOCKOUT) AND timer<100 AND READ_PULSE = '1' then
--					
--					READ_PULSE		<=	'0';
--				
--				elsif timer = 100 then
--					
--					READ_OK	<= '1';
--				
--				end if;
	
			when others => 	
				
				state		<= STANDBY;
				
		end case;	
	end process;
	
counter_up: process (CLOCKOUT, SW(17),timer_en)
	begin
		if SW(17) = '1' or timer_rst = '1' then
			timer <= 0;
		elsif rising_edge(CLOCKOUT) and timer_en = '1' then
			timer <= timer + 1;
		end if;
	end process;
	
	PROCESS(CLOCK_50, SW(17))
		
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX := 0;
		
		BEGIN
		
			if SW(17) = '1' then
				counter := 0;		
		
			elsif (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
			
				IF counter < COUNT_MAX THEN
					counter := counter + 1;
				ELSE
					counter := 0;
					clock   <= NOT clock;
				
				END IF;
			END IF;
		END PROCESS;
		
		CLOCKOUT <= clock;
	
--DISPLAY_MENU: WORK.display
--	
--	PORT MAP(
--		color,
--		dist_cm,
--		selecao,
--		
--		HEX0,
--		HEX1,
--		HEX2,
--		HEX3,
--		HEX4,
--		HEX5,
--		HEX6,
--		HEX7
--		);
--	
--BOTAO_MENU: WORK.debouncer_pi
--
--	PORT MAP(
--		CLOCK_50,
--		KEY(0),
--		buttonOut
--		);
--		
--	sel_face: PROCESS (buttonOut) 
--	BEGIN
--	  
--		IF (buttonOut'EVENT AND buttonOut='1') THEN
--
--			IF (selecao = 1) THEN
--				selecao <= 0;
--			ELSE
--				selecao <= selecao + 1;
--			END IF;
--		END IF;
--	END PROCESS;
--	-- Fim seleção interface
--		
	
END;