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
	LEDG: 	OUT STD_LOGIC_VECTOR (8 downto 0);
	--GPIO_RESET:		IN STD_LOGIC;							--pinplaner SW17
	GPIO:	INOUT STD_LOGIC_VECTOR (8 DOWNTO 0)
		
);	
	
END MAIN;


ARCHITECTURE HARDWARE OF MAIN IS

	SIGNAL SEL: 		STD_LOGIC_VECTOR (2 DOWNTO 0);		--fio para interligar as entidades
	SIGNAL DEB_OUT: 	STD_LOGIC ;
	SIGNAL ENABLE: 	STD_LOGIC ;
	SIGNAL COR_L1: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL COR_L2: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL COR_L3: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL ALT_UNI: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL ALT_DEZ: 	STD_LOGIC_VECTOR (6 DOWNTO 0);
	SIGNAL MOTOR:		STD_LOGIC;
	SIGNAL MOTOR2:		STD_LOGIC;
	
	
	BEGIN
	
	
---------------------------------------------------DIVISOR DE CLOCK
	process(CLOCK_50)
	
		variable counter : INTEGER range 0 to 200000000 := 0;
		begin
			if RISING_EDGE(CLOCK_50) then
				if counter < 200000000 then
					counter := counter + 1;
				else
					counter := 0;
					ENABLE <= NOT ENABLE;
				end if;
			end if;
	end process;
-------------------------------------------------------------------
	
	
	
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
			COR_L1,
			COR_L2,
			COR_L3,
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
	
	PORT MAP(CLOCK_50, GPIO(0), MOTOR2, GPIO(3), ALT_UNI, ALT_DEZ);
		
			--(CLOCK_IN, ECHO,    TRIGGER, DISPLAY_UNI, DISPLAY_DEZ)
	
	BLOCO_COR: WORK.sensor_cor
	
		PORT MAP(		CLOCK_50,
							ENABLE,
							GPIO 	(4),		-- GPIO S0
							GPIO 	(5),		-- GPIO S1
							GPIO 	(6),		-- GPIO S2
							GPIO 	(7),		-- GPIO S3
							GPIO 	(8),		-- GPIO out
							MOTOR,
							COR_L1,   -- COR JA EM FORMATO 7SEG
							COR_L2, -- COR JA EM FORMATO 7SEG
							COR_L3  -- COR JA EM FORMATO 7SEG
		);
	
			--				CLOCK_50,
			--				ENABLE,
			--				POWER_0	: OUT	std_logic;		-- GPIO S0
			--				POWER_1	: OUT	std_logic;		-- GPIO S1
			--				FILTER_2	: OUT	std_logic;		-- GPIO S2
			--				FILTER_3	: OUT	std_logic;		-- GPIO S3
			--				MOTOR		: OUT	std_logic;		-- SAIDA PARA LOGICA MOTOR
			--				OUT_SENSOR,		-- GPIO out
			--				RB,   -- COR JA EM FORMATO 7SEG
			--				EL, -- COR JA EM FORMATO 7SEG
			--				DU  -- COR JA EM FORMATO 7SEG

	BLOCO_MOTOR: work.MOTOR
		PORT MAP	(		CLOCK_50,
				SEL,
				MOTOR,	-- 
				MOTOR2,	-- 
				LEDG(0)		-- 
			--	MOTORP0		: out std_logic;
			--	MOTORP1		: out std_logic;
				--MOTORP2		: out std_logic;
				--MOTORP3		: out std_logic;
				--COMUM		: out std_logic;
		);
	
	LEDG(1) <= MOTOR;
	LEDG(4) <= MOTOR2;
	
END HARDWARE;