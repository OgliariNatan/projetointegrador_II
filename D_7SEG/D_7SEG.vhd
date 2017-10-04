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
				freqOut 		: INTEGER :=1 				--Saida do divisor de clock
	);
	
	PORT(	--Definições dos sinais de entrada
			clock_50			: IN STD_LOGIC;--Entrada do clock da placa
			CLOCKOUT			: OUT STD_LOGIC; --POSSIVEL SAIDA DO DIVISOR DE CLOCK
		
			-- Sensor de distância
			GPIO					:inout  STD_LOGIC_VECTOR (35 DOWNTO 0);	-- Declara um Buffer para que possamos utilizar com I/O
			--GPIO(1) = echo
			--GPIO(0) = trigger	
	
			--Definições de botão de ajuste 
			  KEY					: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
			  SW					: IN STD_LOGIC_VECTOR (17 DOWNTO 0);

			--Definição do display_7Segmentos
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: OUT STD_LOGIC_VECTOR (0 TO 6);

			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut			: BUFFER STD_LOGIC;
			END_TRIGGER			: BUFFER STD_LOGIC := '1';
			HC_ENABLE			: BUFFER STD_LOGIC := '0'; -- habilitador de leitura do sensor de altura
			
			--DECLARAÇÂO DE LED para testes
			LEDR					: OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
		);
	
END D_7SEG;

ARCHITECTURE display OF D_7SEG IS --declaração das variaveis
	--Divisor de frequencia
	SIGNAL count 					: INTEGER :=1; --divisão do clock
	SIGNAL clk_sd	  		  	   : STD_LOGIC :='0';	-- Clock para sensor de distancia
	
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
	
	BEGIN--Começa a logica do programa

BOTAO_MENU: WORK.debouncer_pi

	PORT MAP(
		CLOCK_50,
		KEY(0),
		buttonOut
		);
	
		-- Seleção da interface
	PROCESS (buttonOut) 
	BEGIN
	
	
	  
		IF (buttonOut'EVENT AND buttonOut='1') THEN

			IF (selecao = 1) THEN
			ELSE
				selecao <= selecao + 1;
			END IF;
		END IF;
		
	END PROCESS;
	-- Fim seleção interface
	
	
DISPLAY_MENU:WORK.display
	
	PORT MAP(
		color,
		altura,
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

		
END display;
