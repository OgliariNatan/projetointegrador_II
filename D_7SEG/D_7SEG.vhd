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
			GPIO					:INOUT STD_LOGIC_VECTOR (35 DOWNTO 0);	-- Declara um Buffer para que possamos utilizar com I/O				  
			--GPIO(1) = echo
			--GPIO(0) = trigger	
	
			--Definições de botão de ajuste 
			  KEY					: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
			  SW					: IN STD_LOGIC_VECTOR (17 DOWNTO 0);

			--Definição do display_7Segmentos
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: OUT STD_LOGIC_VECTOR (0 TO 6);

			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut			: BUFFER STD_LOGIC;
			
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
	
	--DIVISOR DE CLOCK
	SIGNAL clock			 : STD_LOGIC :='0';
	CONSTANT COUNT_MAX1   : INTEGER := ((freqIn/freqOut)/2)-1;

	BEGIN
	
BOTAO_MENU: WORK.debouncer_pi

	PORT MAP(
		CLOCK_50,
		KEY(0),
		buttonOut
		);

	
		
	--DIVISOR DE CLOCK
	PROCESS(clock_50)
	
		VARIABLE counter : INTEGER RANGE 0 TO COUNT_MAX1 := 0;
	
	BEGIN
	
		IF (clock_50'EVENT AND clock_50 = '1') THEN
		
			IF counter < COUNT_MAX1 THEN
				counter := counter + 1;
			ELSE
				counter := 0;
				clock   <= NOT clock;
			
			END IF;
		END IF;
	END PROCESS;
	CLOCKOUT <= clock;
		

	
		-- divisor de frequencia
		PROCESS (clock_50)
		BEGIN
			IF (clock_50'EVENT AND clock_50 ='1') THEN
				count    <= count + 1;
			END IF;
			
		END PROCESS;
		-- Fim divisor de frequncia
		
	PROCESS (buttonOut)
	
	BEGIN
	
	--APAGAR INICIO
			IF (SW(1) = '1') THEN
			LEDR(9) <= '1';
			LEDR(10) <= '0';
			GPIO(0) <= '0';
			END IF;
			
			
			IF (SW(0) = '1') THEN
							
			LEDR(10) <= '1';
			GPIO(0) <= '1';
		   LEDR(9) <= '0';	

			END IF;		
			--APAGAR FIM
	
	END PROCESS;
		
	
		-- Seleção da interface
	PROCESS (buttonOut) 
	
	BEGIN
	
	
	   --selecao <= 0; --APAGAR
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
