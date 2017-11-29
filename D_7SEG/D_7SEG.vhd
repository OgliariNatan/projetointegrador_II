--Autores: Augusto & Natan Ogliari
--Arquivo para mostrar informações no display de 7 segmentos, no kit DE2-115
--"correndo os dados"
--chip: EP4CE115F29C7N
--Projeto para a disciplina de Projeto Integrador II

LIBRARY ieee;
LIBRARY work;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


ENTITY D_7SEG IS
	--Defenições genericas

	GENERIC(	freqIn			: INTEGER := 50000000;  --Frequencia da placa
				defaultState 	: STD_LOGIC := '0'; 	--Define dois estados "1" "0"
				freqOut 			: INTEGER :=1000000 		--Saida do divisor de clock
	);

	PORT(	--Definições dos sinais de entrada
			CLOCK_50				: IN STD_LOGIC;--Entrada do clock da placa


			-- Sensor de distância
			GPIO					: INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);	-- Declara os pinos GPIO como I/O
			--GPIO(1) = echo
			--GPIO(2) = Trigger

			--Definições de botão de ajuste
			KEY					: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
			SW						: IN STD_LOGIC_VECTOR (17 DOWNTO 0);

			--Definição do display_7Segmentos
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: OUT STD_LOGIC_VECTOR (0 TO 6);

			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut			: BUFFER STD_LOGIC;

			--DECLARAÇÂO DE LED para testes
			LEDR					: OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
			LEDG					: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

			---Configurações do sensor de cor
			areset		: in std_logic  := '0';
			inclk0		: in std_logic  := '0';
			c0				: out std_logic;

			clk_50Mhz 	: in std_logic;			-- 50MHz input clock
			rst 			: in std_logic;			-- input clock

			data_in : in std_logic;		-- sensor data input

			freq_sel : in std_logic_vector(1 downto 0);
			-- freq_sel
			-- "00" Power down
			-- "10" 002% 	010~012 kHz
			-- "01" 020%	100~120 kHz
			-- "11" 100%	500~600 kHz   <--- Validated

			s_out :OUT std_logic_vector(3 downto 0);	-- Filter selection
			red 	: buffer std_logic;							-- '1' if red is detected
			blue 	: buffer std_logic;							-- '1' if blue is detected
			green	: buffer std_logic;
			--FIM da configuração de cor

			--Configuração do pwmDC
			setVel		:IN std_logic_vector(3 downto 0);
			vel 			:IN std_logic_vector(3 downto 0);
			onOF		 	:OUT std_logic
			--FIM da configuração do pwmDC
		);

END D_7SEG;

ARCHITECTURE display OF D_7SEG IS --declaração das variaveis

	--seleção de interface
	SIGNAL 	selecao 				: INTEGER RANGE 0 TO 1:= 0; --Numero de seleção

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
	SIGNAL	dist_cm				: INTEGER range 0 to 511;
	SIGNAL   clock					: STD_LOGIC := '0';
	CONSTANT COUNT_MAX			: INTEGER 	:= ((freqIn / freqOut) / 2)-1;


	CONSTANT MAX_DIST 			: INTEGER := 13; -- Variavel para o fundo de escala do sensor de distancia
	signal	CLOCKOUT				: STD_LOGIC; --POSSIVEL SAIDA DO DIVISOR DE CLOCK

	TYPE State_type IS (STANDBY, DISP_TRIGGER, WAIT_ECHO, MEASURE, END_LOOP, WAITING);  -- Define os estados da maquina de estados

	signal state 					: State_Type;    -- Variavell que recebe o proximo estado da maquina de estados
	signal timer 					: integer range 0 to 131071;
	signal timer_rst 				: std_logic;
	signal timer_en 				: std_logic;
	signal reg_data_en	  		 : std_logic;

	BEGIN--Começa a logica do programa


	fsm_state: PROCESS(CLOCKOUT, SW(17)) --SW(17)=RST
	begin

		if SW(17) = '1' then
			state <= STANDBY;

		elsif rising_edge(CLOCKOUT) then

			case state is
				when STANDBY =>

					if (SW(14) = '1') then
						state <= DISP_TRIGGER;
					else
						state <= STANDBY;
					end if;

				when DISP_TRIGGER =>

					if (timer <= 10) then
						state <= DISP_TRIGGER;
					else
						state <= WAIT_ECHO;
					end if;

				when WAIT_ECHO =>

					if (GPIO(1) = '0') then
						if timer > 100000 then
							state <= STANDBY;
						else
							state <= WAIT_ECHO;
						end if;
					else
						state <= MEASURE;
					end if;


				when MEASURE =>

					if (GPIO(1) = '1') then
						state <= MEASURE;
					else
						state <= END_LOOP;
					end if;


				when END_LOOP =>
					state <= WAITING;


				when WAITING =>

					if timer <= 100000 then
						state <= WAITING;
					else
						state <= STANDBY;
					end if;

				when others =>

					state <= STANDBY;

			end case;
		end if;
	end process;

	fsm_moore: process(state, timer)
	begin

		timer_rst <= '0';
		timer_en <= '1';
		reg_data_en <= '0';
		GPIO(2) <= '0'; -- Zera o TRIGGER por padrão.

		case state is

			when STANDBY =>
				LEDR(17 downto 12) <= "100000";

				timer_rst <= '1';

			when DISP_TRIGGER =>
				LEDR(17 downto 12) <= "010000";

				if (timer <= 10) then
					GPIO(2) <= '1';
				else
					GPIO(2) <= '0';
				end if;

			when WAIT_ECHO =>
				LEDR(17 downto 12) <= "001000";
				timer_en <= '0';

			when MEASURE =>
				LEDR(17 downto 12) <= "000100";

			when END_LOOP =>
				LEDR(17 downto 12) <= "000010";

				timer_en <= '0';
				reg_data_en <= '1';

			when WAITING =>
				LEDR(17 downto 12) <= "000001";

			when others =>
				LEDR(17 downto 12) <= "111111";

		end case;
	end process;


	counter_up: process (CLOCKOUT, SW(17), timer_rst, timer_en)
	begin
		if SW(17) = '1' or timer_rst = '1' then
			timer <= 0;
		elsif rising_edge(CLOCKOUT) and timer_en = '1' then
			timer <= timer + 1;
		end if;
	end process;


	reg_data: process (CLOCKOUT, SW(17), reg_data_en)
	begin
		if SW(17) = '1' then
			dist_cm <= 0;
		elsif rising_edge(CLOCKOUT) and reg_data_en = '1' then
			dist_cm <= (timer - 10)/58; -- subtrai o off-set do contador
		end if;
	end process;


	---------------------------------------------Inicio cor
	SENSOR_COR: WORK.tcs230

	PORT MAP(
		CLOCK_50,
		SW(11),				-- iniciador do processo de leitura , RESET

		GPIO(15),		-- saida em frequencia do sensor, entrada de dados da maquina de estados

		"11",				-- escala máxima de frequência


		GPIO(35 DOWNTO 32),			-- seletor do filtro para cor - porque é uma saída? porque tem 4 bits? GPIO(35)=S3
		red,
		blue,
		green
		);


	--------------------------------------------FIM cor

BOTAO_MENU: WORK.debouncer_pi

	PORT MAP(
		CLOCK_50,
		KEY(0),
		buttonOut
		);

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


	-- Seleção da interface
	sel_face: PROCESS (buttonOut)
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


DISPLAY_MENU: WORK.display

	PORT MAP(
		green,
		blue,
		red,

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

CONTROL_PWM: work.pwmDC

	PORT MAP(
		clk_50Mhz, 			-- 50MHz input clock
		rst, 		 			-- input ENABLE
		setVel,				-- Seleciona a velocidade com motor comm 4bits
		LEDG
	);



END display;
