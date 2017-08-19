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


ENTITY display_7SEG IS
	--Defenições genericas
	GENERIC(	freqIn			: INTEGER := 50000000; --Frequencia da placa
				delay				: INTEGER := 100;		  --Atraso do ruido de botão
				defaultState	: STD_LOGIC := '0' 	  --Define dois estados "1" "0"
	);
	
	PORT(	--Definições dos sinais de entrada
			clock_50: 	IN STD_LOGIC;--Entrada do clock da placa
			--Definições dos I/O do sensor ultrasonico
			trigger: 	OUT STD_LOGIC;
			echo: 		IN STD_LOGIC;
			--Definições de botão de ajuste 
			KEY: 			IN STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
			SW: 			IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			--Definição do Sensor de cor
			S0: 			OUT STD_LOGIC;
			S1: 			OUT STD_LOGIC;
			S2: 			OUT STD_LOGIC;
			S3: 			OUT STD_LOGIC;
			OUT_SC: 		IN STD_LOGIC;
			--Definição do display_7Segmentos
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, HEX8: OUT STD_LOGIC_VECTOR (0 TO 6);
			--Definição de saidas do led da placa 
			LEDR: 		OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
			--Definição da saida do "botão virtual" de antitrepidação
			buttonOut:  BUFFER STD_LOGIC
		);
	
	
END display_7SEG;

ARCHITECTURE display OF display_7SEG IS
	--blá blá

	--PROCESS(clockin)--Para deixar o codigo em serie
	--BEGIN --Começa a logica do programa
	--blá blá
	--END PROCESS
	--SIGNAL x : STRING (1 TO 3) := "Alo";
	--SIGNAL y : STRING (1 TO 5) := "Mundo";
	
	BEGIN --Começa a logica do programa
	--c <= x & " " & y;
	--d <= x (1 TO 2) & "o " & y;
	
END display;



