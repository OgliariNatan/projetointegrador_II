--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	ENTIDADE MAIN							=>interliga as demais entidades e as conecta ao kit fpga
--														
-- 	AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		MARÇO DE 2017



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY MAIN IS PORT(

	CLOCK_50: IN STD_LOGIC;

	KEY :		IN	STD_LOGIC_VECTOR (3 DOWNTO 0);
	HEX7:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX6:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX5:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX4:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX3:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX2:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX1:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	HEX0:	  OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);
	
	--GPIO_RESET:		IN STD_LOGIC;							--pinplaner SW17
	GPIO_ECHO:		IN STD_LOGIC;
	GPIO_TRIGGER:	OUT STD_LOGIC
	
);	
	
END MAIN;


ARCHITECTURE HARDWARE OF MAIN IS

	SIGNAL SEL: 		STD_LOGIC_VECTOR (2 DOWNTO 0);		--fio para interligar as entidades
	SIGNAL DEB_OUT: 	STD_LOGIC ;
	SIGNAL ALT_UNI: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL ALT_DEZ: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	
	
	BEGIN
	
	BLOCO_00: WORK.debouncer_pi
	
		PORT MAP(
			CLOCK_50,
			KEY(0),
			DEB_OUT
		);
			
	
	BLOCO_01:	WORK.SELETOR
	
		PORT MAP(
			DEB_OUT,
			SEL
		);
				
				
	BLOCO_02: WORK.MENU
			
		PORT MAP(
			SEL,
	--		DADOS,									--AQUI VAI ENTRAR OS DADOS PARA EXIBIR
			ALT_UNI,
			ALT_DEZ,
			HEX0,
			HEX1,
			HEX2,
			HEX3,
			HEX4,
			HEX5,
			HEX6,
			HEX7
		);
		
		
	BLOCO_03: WORK.sen_alt_7seg
	
	PORT MAP(CLOCK_50, GPIO_ECHO,	GPIO_TRIGGER, ALT_UNI, ALT_DEZ);
		
	--(CLOCK_IN, ECHO, TRIGGER, DISPLAY_UNI, DISPLAY_DEZ)

	
	
END HARDWARE;