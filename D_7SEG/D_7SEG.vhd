--Autores: Augusto & Natan Ogliari
--Arquivo para mostrar informações no display de 7 segmentos, no kit DE2-115
--"correndo os dados"
--chip: EP4CE115F29C7N
--
--DISPLAY 7SEGMENTOS (Ativo em nivel logico BAIXO "abcdefg")
--Segmentos do  display=Pino do display
--a=0         a
--b=1       ----
--c=2     f|    |b
--d=3      |  g |
--e=4       ----
--f=5     e|    |c
--g=6      |   d|
--ponto=7   ---- .ponto

LIBRARY ieee;
LIBRARY work;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY D_7SEG IS
	--Defenições genericas
	GENERIC(	freqIn		: INTEGER := 50000000;  --Frequencia da placa
				defaultState : STD_LOGIC := '0'; 	--Define dois estados "1" "0"
				freqOut 		: INTEGER :=1000000 		--Saida do divisor de clock
	);
	
	PORT(	--Definições dos sinais de entrada
			CLOCK_50			: IN STD_LOGIC;--Entrada do clock da placa
		
		
			-- Sensor de distância
			GPIO					: INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);	-- Declara um Buffer para que possamos utilizar com I/O
			--GPIO(1) = echo
			--GPIO(2) = GPIO(2)	
	
			--Definições de botão de ajuste 
			  KEY					: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
			  SW					: IN STD_LOGIC_VECTOR (17 DOWNTO 0);

			--Definição do display_7Segmentos
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: OUT STD_LOGIC_VECTOR (0 TO 6);

			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut			: BUFFER STD_LOGIC;
			--END_GPIO(2)			: BUFFER STD_LOGIC := '1';
			--HC_ENABLE			: BUFFER STD_LOGIC := '0'; -- habilitador de leitura do sensor de altura
			--new_enable			: BUFFER STD_LOGIC; --APAGAR 
			
			--DECLARAÇÂO DE LED para testes
			LEDR					: OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
		);
	
END D_7SEG;

ARCHITECTURE display OF D_7SEG IS --declaração das variaveis
	--Divisor de frequencia
	SIGNAL count 					: INTEGER :=1; --divisão do clock
	--SIGNAL clk_sd	  		  	   : STD_LOGIC :='0';	-- Clock para sensor de distancia
	
	--seleção de interface

	SIGNAL selecao 		: INTEGER RANGE 0 TO 1:= 0; --Numero de seleção
	
	-- Sensor de distância
	SIGNAL 	distancia     		: INTEGER := 0;			-- Calculo da distância
	SIGNAL 	cont_sensor 		: INTEGER := 0; 			-- Variavel para calculo
	SIGNAL 	cont_d				: INTEGER := 0;			-- Variavel para calculo
	SIGNAL 	tempo_sd 			: INTEGER := 0;			-- Variavel para calculo
	SIGNAL 	t_caixa 				: INTEGER := 0;			-- Tamanho calculado
	SIGNAL 	li						: INTEGER;					-- Leitura inicial	
	SIGNAL	color					: STD_LOGIC := '0';
	SIGNAL	altura				: INTEGER := 99;
	--SIGNAL	dist_mm				: INTEGER;
	SIGNAL	dist_cm				: INTEGER;
	SIGNAL   clock					: STD_LOGIC := '0';
	CONSTANT COUNT_MAX			: INTEGER 	:= ((freqIn / freqOut) / 2)-1;
	
	signal	CLOCKOUT			: STD_LOGIC; --POSSIVEL SAIDA DO DIVISOR DE CLOCK
	
	BEGIN--Começa a logica do programa

BOTAO_MENU: WORK.debouncer_pi

	PORT MAP(
		CLOCK_50,
		KEY(0),
		buttonOut
		);
		
	--GPIO(1) <= CLOCKOUT;

		PROCESS(CLOCK_50)
		
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX := 0;
		
		BEGIN
		
			IF (CLOCK_50'EVENT AND CLOCK_50 = '1') THEN
			
				IF counter < COUNT_MAX THEN
					counter := counter + 1;
				ELSE
					counter := 0;
					clock   <= NOT clock;
				
				END IF;
			END IF;
		END PROCESS;
		CLOCKOUT <= clock;	


	PROCESS(CLOCKOUT, SW)
		
		TYPE State_type IS (STANDBY, DISP_TRIGGER, WAIT_ECHO, MEASURE);  -- Define the states
		
		variable NEXT_STATE : State_Type;    -- Create a variable that uses 
	
		
		--VARIABLE STATE			:	INTEGER RANGE 0 TO 3 := 0;
		--VARIABLE NEXT_STATE	:	INTEGER RANGE 0 TO 3 := 0;
		
		VARIABLE	counter 		: INTEGER := 0;
		
		CONSTANT	COUNT_MAX		: INTEGER 	:= 500; --10us
		CONSTANT MAX_DIST			: INTEGER	:= 13;
		--CONSTANT IDLE				: integer := 0
		--CONSTANT STANDBY			: integer := 0;
		--CONSTANT DISP_TRIGGER 	: integer := 1;
		--CONSTANT WAIT_ECHO  		: integer := 2;
		--constant MEASURE			: integer := 3;	
		
		BEGIN
		
			if SW(17) = '1' then
				NEXT_STATE := STANDBY;
				LEDR(17 DOWNTO 14) <= "0000";
				counter := 0;
			else		
				if rising_edge(CLOCKOUT) then
						--NEXT_STATE := STANDBY;			
						CASE NEXT_STATE IS
							
							when STANDBY => 
								LEDR(17 DOWNTO 14) <= "1000";
								counter := 0;	
								IF(sw(0) = '0') then
									NEXT_STATE := STANDBY;
								else
									NEXT_STATE := DISP_TRIGGER;
								end if;
											
							WHEN DISP_TRIGGER =>														
								LEDR(17 DOWNTO 14) <= "0100";
								IF (counter <= 10) THEN
									GPIO(2) <= '1';	--TRIGGER							
									NEXT_STATE := DISP_TRIGGER;
			
									counter := counter + 1;		
								else
									counter := 0;
									GPIO(2) <= '0';
									NEXT_STATE := WAIT_ECHO;							
								END IF;
							
							WHEN WAIT_ECHO =>
								LEDR(17 DOWNTO 14) <= "0010";
								counter := counter + 1;
								if GPIO(1) = '0' then
									
									if counter < 10000 then
										NEXT_STATE := WAIT_ECHO;
									else
										NEXT_STATE := STANDBY;
									END IF;
									
								else
									NEXT_STATE := MEASURE;
									counter := 0;	
								end if;
								
							when MEASURE =>
								LEDR(17 DOWNTO 14) <= "0001";
								if GPIO(1) = '1' then						
									counter := counter + 1;
									NEXT_STATE := MEASURE;
								else
									dist_cm <= MAX_DIST - (counter)/58;
									--dist_mm <= MAX_DIST - (counter*10)/58;
									
									--if (SW(0) = '1') then								
										--NEXT_STATE := MEASURE;
									--else
										NEXT_STATE := STANDBY;
										counter := 0;
									--end if;
								end if;
						END CASE;
				end if;
			end if;
		END PROCESS;
	

	
	-- Seleção da interface
	PROCESS (buttonOut) 
	BEGIN
	  
		IF (buttonOut'EVENT AND buttonOut='1') THEN

			IF (selecao = 1) THEN
				selecao <= 0;
			ELSE
				selecao <= selecao + 1;
			END IF;
		END IF;
		
	END PROCESS;
	-- Fim seleção interface
	
	
DISPLAY_MENU:WORK.display
	
	PORT MAP(
		color,
		dist_cm,
		selecao,
		
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		HEX6,
		HEX7
		);

		
--SENSOR_ALTURA: WORK.hc_sr04
--	
--	PORT MAP(
--	CLOCK_50,
--	SW(0),
--	GPIO(1),
--	GPIO(2),
--	altura
--	);

		
END display;
