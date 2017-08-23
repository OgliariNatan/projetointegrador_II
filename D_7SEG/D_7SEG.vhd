--Autores: Augusto & Natan Ogliari
--Arquivo para mostrar informações no display de 7 segmentos, no kit DE2-115
--"correndo os dados"
--chip: EP4CE115F29C7N
--
--DISPLAY 7SEGMENTOS
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
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY D_7SEG IS
	--Defenições genericas
	GENERIC(	freqIn		: INTEGER := 50000000; --Frequencia da placa
				delay			: INTEGER := 100;		  --Atraso do ruido de botão
				defaultState: STD_LOGIC := '0' 	  --Define dois estados "1" "0"
	);
	
	PORT(	--Definições dos sinais de entrada
			clock_50			: IN STD_LOGIC;--Entrada do clock da placa

			--Definições de botão de ajuste 
			KEY				: IN STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
			SW					: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			--Definição do Sensor de cor

			--Definição do display_7Segmentos
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, HEX8: OUT STD_LOGIC_VECTOR (0 TO 6);

			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut		: BUFFER STD_LOGIC
		);
	
END D_7SEG;

ARCHITECTURE display OF D_7SEG IS --declaração das variaveis
	--Divisor de frequencia
	SIGNAL count 			: INTEGER :=1; --divisão do clock
	--seleção de interface
	SIGNAL selecao 		: INTEGER RANGE 0 TO 2; --Numero de seleção
	--Antitrepidação
	SIGNAL buttonAux 		: STD_LOGIC :='0';
	SIGNAL buttonPressed : STD_LOGIC :='0';
	CONSTANT cont_max		: INTEGER := ((freqIn/1000)*delay)-1;	
	
	BEGIN--Começa a logica do programa
	
	--Antitrepidação *codigo do professor*
	buttonAux <= KEY(0) WHEN defaultState = '0' ELSE (NOT KEY(0));
	PROCESS(CLOCK_50)
			VARIABLE counter : INTEGER RANGE 0 TO CONT_MAX := 0;
			
		BEGIN
			IF RISING_EDGE(CLOCK_50) THEN
				IF buttonPressed = '0' AND buttonAux = '1' THEN
					buttonPressed <= '1';
					counter := 0;
				ELSIF buttonPressed = '1' AND buttonAux = '1' THEN
					counter := 0;
				ELSIF buttonPressed = '1' AND buttonAux = '0' THEN
					IF counter < CONT_MAX THEN
						counter := counter + 1;
					ELSE
						counter := 0;
						buttonPressed <= '0';
					END IF;
				END IF;
			END IF;
		END PROCESS;
		buttonOut <= buttonPressed WHEN defaultState = '0' ELSE (NOT buttonPressed);
		-- Fim Antitrepidação
	
		-- divisor de frequncia
		PROCESS (clock_50)
		BEGIN
			IF (clock_50'EVENT AND clock_50 ='1') THEN
				count    <= count + 1;
			END IF;
		END PROCESS;
		-- Fim divisor de frequncia
	
END display;






