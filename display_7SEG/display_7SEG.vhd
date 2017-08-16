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
	--GENERIC(	freqIn			: INTEGER := 50000000;
	--			delay				: INTEGER := 100;
	--			defaultState	: STD_LOGIC := '0'
	--);
	--PORT(	--Sinais de entrada
	--		clockIn		: IN STD_LOGIC;
	--		buttonIn		: IN STD_LOGIC;
	--		--Sinais de saida
	--		buttonOut	: OUT STD_LOGIC
	--);
	
	--PORT (CLOCK :IN );
	PORT (c, d : OUT STRING (1 TO 9));--APAGAR
	
END display_7SEG;

ARCHITECTURE display OF display_7SEG IS
	--blá blá

	--PROCESS(clockin)--Para deixar o codigo em serie
	--BEGIN --Começa a logica do programa
	--blá blá
	--END PROCESS
	SIGNAL x : STRING (1 TO 3) := "Alo";
	SIGNAL y : STRING (1 TO 5) := "Mundo";
	
	BEGIN --Começa a logica do programa
	c <= x & " " & y;
	d <= x (1 TO 2) & "o " & y;
	
END;



