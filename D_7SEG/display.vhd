LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY display IS 
	PORT
	(
		VERDE				: IN STD_LOGIC;
		AZUL				: IN STD_LOGIC; 
		VERM				: IN STD_LOGIC;
		
		ALTURA			: IN INTEGER;
		SELECAO			: IN INTEGER;
		
		DISPLAY0			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY1			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY2			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY3			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY4			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY5			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY6			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		DISPLAY7			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
	
END display;
	
ARCHITECTURE behavior OF display IS
	
	--SIGNAL tamanho		: INTEGER;
	SIGNAL unit_size	: INTEGER;
	SIGNAL ten_size	: INTEGER;
	SIGNAL conv_unit	: STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL conv_ten	: STD_LOGIC_VECTOR (6 DOWNTO 0);
	
	BEGIN
	
	--tamanho <= ALTURA;
			
	ten_size  <= (ALTURA/10);    	
	unit_size <=  (ALTURA - (ten_size*10));
	
		DECODE_UNIT: WORK.sevenSeg_decoder
	
		PORT MAP(
		unit_size,
		conv_unit
		);
		
	DECODE_TEN: WORK.sevenSeg_decoder
	
		PORT MAP(
		ten_size,
		conv_ten
		);
				
	PROCESS(AZUL, VERM, ALTURA,SELECAO, conv_ten, conv_unit)
	
		
		BEGIN
		
		IF (SELECAO = 0) THEN
		
			
			DISPLAY7 <= "0001000"; -- A
			DISPLAY6 <= "1110001"; -- L
			DISPLAY5 <= "1110000"; -- T
			DISPLAY4 <= "1111111"; -- 
			DISPLAY3 <= conv_ten;
			DISPLAY2 <= conv_unit;
			DISPLAY1 <= "0110001"; -- C
			--DISPLAY1 <= "1101010"; -- m
			DISPLAY0 <= "1101010"; -- m
		
		
		ELSIF (selecao = 1) THEN
	
			IF(VERM = '1') THEN
				DISPLAY7 <= "0110001"; -- C
				DISPLAY6 <= "0000001"; -- O  
				DISPLAY5 <= "1111010"; -- R 
				DISPLAY4 <= "1111111"; -- -
				DISPLAY3 <= "1111010"; -- R 
				DISPLAY2 <= "0110000"; -- E  
				DISPLAY1 <= "1000010"; -- D 
				DISPLAY0 <= "1111111"; -- -
			
			ELSIF(AZUL = '1') THEN
				DISPLAY7 <= "0110001"; -- C
				DISPLAY6 <= "0000001"; -- O
				DISPLAY5 <= "1111010"; -- R 
				DISPLAY4 <= "1111111"; -- -
				DISPLAY3 <= "1100000"; -- B 
				DISPLAY2 <= "1110001"; -- L 
				DISPLAY1 <= "1000001"; -- U 
				DISPLAY0 <= "0110000"; -- E
			
			ELSIF(VERDE = '1') THEN
				DISPLAY7 <= "0110001"; -- C
				DISPLAY6 <= "0000001"; -- O
				DISPLAY5 <= "1111010"; -- R 
				DISPLAY4 <= "1111111"; -- -
				DISPLAY3 <= "0000100"; -- G 
				DISPLAY2 <= "1111010"; -- R 
				DISPLAY1 <= "1111010"; -- R 
				DISPLAY0 <= "0110000"; -- E
			ELSE
				DISPLAY7 <= "0100100"; -- s 
				DISPLAY6 <= "0110000"; -- e
				DISPLAY5 <= "1101010"; -- m 
				DISPLAY4 <= "1111111"; -- 
				DISPLAY3 <= "0110001"; -- c 
				DISPLAY2 <= "0000001"; -- o
				DISPLAY1 <= "1111010"; -- r 
				DISPLAY0 <= "1111111"; -- 
			
			END IF;
 
		END IF;
		
	END PROCESS;
	
END behavior;
