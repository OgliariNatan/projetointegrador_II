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
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY D_7SEG IS
	--Defenições genericas
	GENERIC(	freqIn		: INTEGER := 50000000;  --Frequencia da placa
				delay			: INTEGER := 100;		   --Atraso do ruido de botão
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
			  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, HEX8: OUT STD_LOGIC_VECTOR (0 TO 6);

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
	SIGNAL selecao 		: INTEGER RANGE 0 TO 1; --Numero de seleção 0 TO 1
	
	--Antitrepidação
	SIGNAL buttonAux 		: STD_LOGIC :='0';
	SIGNAL buttonPressed : STD_LOGIC :='0';
	CONSTANT cont_max		: INTEGER   := ((freqIn/1000)*delay)-1;
	
	--DIVISOR DE CLOCK
	SIGNAL clock			 : STD_LOGIC :='0';
	CONSTANT COUNT_MAX1   : INTEGER := ((freqIn/freqOut)/2)-1;
	
	-- Sensor de distância
	SIGNAL distancia     		: INTEGER := 0;			-- Calculo da distância
	SIGNAL cont_sensor 			: INTEGER := 0; 			-- Variavel para calculo
	SIGNAL cont_d					: INTEGER := 0;			-- Variavel para calculo
	SIGNAL tempo_sd 				: INTEGER := 0;			-- Variavel para calculo
	SIGNAL t_caixa 				: INTEGER := 0;			-- Tamanho calculado
	SIGNAL li						: INTEGER;					-- Leitura inicial	
	
	
	BEGIN--Começa a logica do programa
	
		
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
			IF (selecao = 1) THEN --IF (selecao = 2) THEN
				selecao <= 0;
			ELSE
				selecao <= selecao + 1;
			END IF;
		END IF;
		
	END PROCESS;
	-- Fim seleção interface
	
	-- Sensor de distância 
	PROCESS(clk_sd) 
			-- Variaveis
			VARIABLE d			  	: INTEGER   := 0; 
			VARIABLE cl 			: STD_LOGIC := '0';	-- Inicio da leitura	
			
	BEGIN
		
		IF (clk_sd'EVENT AND clk_sd ='1') THEN
			
			LEDR(1)<='1';
			
			IF (GPIO(1) = '1') THEN --GPIO(1) = echo
				tempo_sd <= tempo_sd + 1; -- Contagem do tempo de acionamento do echo
				LEDR(0)<='1';  --DEBUG APAGAR
			END IF;
			
			-- Nova Referencia
			IF (KEY(1) = '0') THEN
				cl := '0';
			END IF;
			
			
			cont_d <= cont_d + 1; -- Contagem para o controle do tempo de leitura
			
			IF (cont_d = 50_000) THEN --800_000
		
				IF(cl = '0') THEN
					li <= ((tempo_sd*20) / 58);	-- Leitura inicial do ambiente de leitura (sem objeto)
					cl := '1';					-- Inicio da leitura
				END IF;
				
				d := ((tempo_sd*20) / 58);	-- Calculo da distancia
				tempo_sd <= 0;				-- Zera o contador do echo
				GPIO(0) <= '1';				-- Aciona o trigger
			END IF;
			
			IF (cont_d = 100_000) THEN --1_000_000
				cont_d <= 0;		-- Fim do ciclo de leitura
				GPIO(0) <= '0';		-- Desaciona o trigger
			END IF;
				
			t_caixa <= (li - d);  	-- Resultado final
				
		END IF;			
	END PROCESS;
	-- Fim sensor de distância
	
	
	
	-- Decodificador display 7 seguimentos
	PROCESS (selecao, clk_sd, t_caixa) --freqOut
		--VARIAVEIS AUXILIARES APAGARA PARA O PROJETO FINAL
		CONSTANT cor		: INTEGER := 2;   	   -- Futura cor recebida da caixa
		CONSTANT conv_sc	: INTEGER := 1;			-- Envio da da cor para display
		--FIM das variaveis auxiliares APAGAR
		
		-- Sensor de distancia
		VARIABLE tamanho_1: INTEGER;
		VARIABLE tamanho_2: INTEGER;
		VARIABLE tamanho_3: INTEGER;
		VARIABLE tamanho_4: INTEGER;
		VARIABLE tam_1    : INTEGER; --display 0
		VARIABLE tam_2    : INTEGER; --display 1
		VARIABLE tam_3    : INTEGER; --display 2
		VARIABLE tam_4    : INTEGER; --display 3
		-- Sensor de cor		
		VARIABLE conversao_1: INTEGER;
		VARIABLE conversao_2: INTEGER;
		VARIABLE conversao_3: INTEGER;
		VARIABLE conversao_4: INTEGER;
		VARIABLE conv_1    : INTEGER; 
		VARIABLE conv_2    : INTEGER;
		VARIABLE conv_3    : INTEGER;
		VARIABLE conv_4    : INTEGER;
	
	 
	BEGIN -- Inicia o codigo
				
		IF (selecao = 1) THEN

			-- Decodificaçao BCD
				tamanho_1 := t_caixa;
				
				tam_1     := tamanho_1/ 1000;    	-- atribui ao tam_1 o digito mais significativo
				tamanho_2 :=  tamanho_1 - tam_1*1000;
	 
				tam_2     := tamanho_2/100;
				tamanho_3 := tamanho_2 - tam_2*100;
		 
				tam_3     := tamanho_3/10;
				tamanho_4 := tamanho_3 - tam_3*10;
		 
				tam_4     := tamanho_4;
			-- Fim decodificaçao BCD
											
						HEX7 <= "0001000"; -- A
						HEX6 <= "1110001"; -- L
						HEX5 <= "1110000"; -- T
						HEX4 <= "1111111"; -- 
			CASE tam_1 IS
				WHEN 0 => HEX3 <= "0000001";
				WHEN 1 => HEX3 <= "1001111";
				WHEN 2 => HEX3 <= "0010010";
				WHEN 3 => HEX3 <= "0000110";
				WHEN 4 => HEX3 <= "1001100";
				WHEN 5 => HEX3 <= "0100100";
				WHEN 6 => HEX3 <= "0100000";
				WHEN 7 => HEX3 <= "0001111";
				WHEN 8 => HEX3 <= "0000000";
				WHEN 9 => HEX3 <= "0000100";
				WHEN OTHERS => NULL;			-- Outras opções é nula
			END CASE;
						
			CASE tam_2 IS
				WHEN 0 => HEX2 <= "0000001";
				WHEN 1 => HEX2 <= "1001111";
				WHEN 2 => HEX2 <= "0010010";
				WHEN 3 => HEX2 <= "0000110";
				WHEN 4 => HEX2 <= "1001100";
				WHEN 5 => HEX2 <= "0100100";
	     		WHEN 6 => HEX2 <= "0100000";
				WHEN 7 => HEX2 <= "0001111";
				WHEN 8 => HEX2 <= "0000000";
				WHEN 9 => HEX2 <= "0000100";
		    	WHEN OTHERS => NULL;			-- Outras opções é nula
			END CASE;
							
			CASE tam_3 IS
				WHEN 0 => HEX1 <= "0000001";
				WHEN 1 => HEX1 <= "1001111";
				WHEN 2 => HEX1 <= "0010010";
				WHEN 3 => HEX1 <= "0000110";
				WHEN 4 => HEX1 <= "1001100";
				WHEN 5 => HEX1 <= "0100100";
				WHEN 6 => HEX1 <= "0100000";
				WHEN 7 => HEX1 <= "0001111";
				WHEN 8 => HEX1 <= "0000000";
				WHEN 9 => HEX1 <= "0000100";
				WHEN OTHERS => NULL;			-- Outras opções é nula
			END CASE;
							
			CASE tam_4 IS
				WHEN 0 => HEX0 <= "0000001";
				WHEN 1 => HEX0 <= "1001111";
				WHEN 2 => HEX0 <= "0010010";
				WHEN 3 => HEX0 <= "0000110";
				WHEN 4 => HEX0 <= "1001100";
				WHEN 5 => HEX0 <= "0100100";
				WHEN 6 => HEX0 <= "0100000";
				WHEN 7 => HEX0 <= "0001111";
				WHEN 8 => HEX0 <= "0000000";
				WHEN 9 => HEX0 <= "0000100";
				WHEN OTHERS => NULL;			-- Outras opções é nula
			END CASE;
		-- Fim altura
				
		-- Cor
			ELSIF (selecao = 0) THEN
				--COR RED
				IF (cor  <= 1) THEN 
					HEX7 <= "0110001"; -- C
					HEX6 <= "0000001"; -- O  
					HEX5 <= "1111010"; -- R 
					HEX4 <= "1111111"; -- -
					HEX3 <= "1111010"; -- R 
					HEX2 <= "0110000"; -- E  
					HEX1 <= "1000010"; -- D 
					HEX0 <= "1111111"; -- -
				
				--COR BLUE
				ELSIF (cor = 2) THEN
					HEX7 <= "0110001"; -- C
					HEX6 <= "0000001"; -- O
					HEX5 <= "1111010"; -- R 
					HEX4 <= "1111111"; -- -
					HEX3 <= "1100000"; -- B 
					HEX2 <= "1110001"; -- L 
					HEX1 <= "1000001"; -- U 
					HEX0 <= "0110000"; -- E
									
				--COR GREEM
				ELSIF (cor = 3) THEN 
					HEX7 <= "0110001"; -- C
					HEX6 <= "0000001"; -- O 
					HEX5 <= "1111111"; --
					HEX4 <= "0000100"; --  G
					HEX3 <= "1111010"; --  R
					HEX2 <= "0110000"; --  E
					HEX1 <= "0110000"; --  E
					HEX0 <= "1011100"; --  N
				END IF;	
			--Fim cor
				
			--Frequencia  do sensor de cor
--			ELSIF (selecao = 1) THEN	
--				conversao_1 := conv_sc;
--				
--				conv_1 := conversao_1/1000;    	-- atribui ao tam_1 o digito mais significativo
--				conversao_2 :=  conversao_1 - conv_1*1000;
--	 
--				conv_2 := conversao_2/100;
--				conversao_3 := conversao_2 - conv_2*100;
--		 
--				conv_3 := conversao_3/10;
--				conversao_4 := conversao_3 - conv_3*10;
--		 
--				conv_4 := conversao_4;
--			-- Fim decodificaçao BCD
--											
--						HEX7 <= "0000000"; -- 
--						HEX6 <= "0000000"; -- 
--						HEX5 <= "0000000"; -- 
--						HEX4 <= "0000000"; -- 
--			CASE conv_1 IS
--				WHEN 0 => HEX3 <= "0000001";
--				WHEN 1 => HEX3 <= "1001111";
--				WHEN 2 => HEX3 <= "0010010";
--				WHEN 3 => HEX3 <= "0000110";
--				WHEN 4 => HEX3 <= "1001100";
--				WHEN 5 => HEX3 <= "0100100";
--				WHEN 6 => HEX3 <= "0100000";
--				WHEN 7 => HEX3 <= "0001111";
--				WHEN 8 => HEX3 <= "0000000";
--				WHEN 9 => HEX3 <= "0000100";
--				WHEN OTHERS => NULL;			-- Outras opções é nula
--			END CASE;
--						
--			CASE conv_2 IS
--				WHEN 0 => HEX2 <= "0000001";
--				WHEN 1 => HEX2 <= "1001111";
--				WHEN 2 => HEX2 <= "0010010";
--				WHEN 3 => HEX2 <= "0000110";
--				WHEN 4 => HEX2 <= "1001100";
--				WHEN 5 => HEX2 <= "0100100";
--	     		WHEN 6 => HEX2 <= "0100000";
--				WHEN 7 => HEX2 <= "0001111";
--				WHEN 8 => HEX2 <= "0000000";
--				WHEN 9 => HEX2 <= "0000100";
--		    	WHEN OTHERS => NULL;			-- Outras opções é nula
--			END CASE;
--							
--			CASE conv_3 IS
--				WHEN 0 => HEX1 <= "0000001";
--				WHEN 1 => HEX1 <= "1001111";
--				WHEN 2 => HEX1 <= "0010010";
--				WHEN 3 => HEX1 <= "0000110";
--				WHEN 4 => HEX1 <= "1001100";
--				WHEN 5 => HEX1 <= "0100100";
--				WHEN 6 => HEX1 <= "0100000";
--				WHEN 7 => HEX1 <= "0001111";
--				WHEN 8 => HEX1 <= "0000000";
--				WHEN 9 => HEX1 <= "0000100";
--				WHEN OTHERS => NULL;			-- Outras opções é nula
--			END CASE;
--							
--			CASE conv_4 IS
--				WHEN 0 => HEX0 <= "0000001";
--				WHEN 1 => HEX0 <= "1001111";
--				WHEN 2 => HEX0 <= "0010010";
--				WHEN 3 => HEX0 <= "0000110";
--				WHEN 4 => HEX0 <= "1001100";
--				WHEN 5 => HEX0 <= "0100100";
--				WHEN 6 => HEX0 <= "0100000";
--				WHEN 7 => HEX0 <= "0001111";
--				WHEN 8 => HEX0 <= "0000000";
--				WHEN 9 => HEX0 <= "0000100";
--				WHEN OTHERS => NULL;			-- Outras opções é nula
--			END CASE;
		END IF;
	END PROCESS;
	-- Fim decodificaçao
	
	
END display;
