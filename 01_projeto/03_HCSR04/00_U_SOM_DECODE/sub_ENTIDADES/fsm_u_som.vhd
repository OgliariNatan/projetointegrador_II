
--INSTITUTO FEDERAL DE SANTA CATARINA

--		PROJETO INTEGRADOR II (2017)

-- 	DIVISOR DE CLOCK PARA SENSOR HCSR04
--														
-- 	AUTORES: 	JEFERSON	PEDROSO
--						TARCIS	BECHER

--		ABRIL DE 2017



LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY fsm_u_som IS
	
	PORT(
		CLOCK, RST: 											IN STD_LOGIC;
		E_SINAL_ECHO, E_SINAL_TRIG, E_SINAL_DELAY:	IN STD_LOGIC;
		S_EN_TRIG, S_RST_ECHO, S_EN_DELAY:				OUT STD_LOGIC
	);

END fsm_u_som;



ARCHITECTURE HARDWARE OF fsm_u_som IS

	TYPE state IS(
		inicio, inicia_trig, gera_trig, espera_echo, mede_echo, inicia_delay, delay
	);
	
	SIGNAL pr_state, nx_state: state;
	
	BEGIN
	-----------------------para o clock

		PROCESS (CLOCK, RST)
			BEGIN
				IF (RST = '0') THEN
					pr_state <= inicio;
				ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
					pr_state <= nx_state;
				END IF;	
		END PROCESS;
		
		
	--------------------- FSM
		PROCESS (pr_state)
			BEGIN
				CASE pr_state IS
					
					WHEN inicio =>
						S_EN_TRIG <= '0';
						S_RST_ECHO <= '0';
						S_EN_DELAY <= '0';
											
						
						IF (RST = '0') THEN
							nx_state <= inicio;
						ELSIF (RST = '1') THEN
							nx_state <= inicia_trig;
						END IF;

						
						
					WHEN inicia_trig =>
						S_EN_TRIG <= '1';
						
						IF (E_SINAL_TRIG = '0') THEN
							nx_state <= inicia_trig;
						ELSIF (E_SINAL_TRIG = '1') THEN
							nx_state <= gera_trig;
						END IF;

						
						
					WHEN gera_trig =>
					
						IF (E_SINAL_TRIG = '1') THEN
							nx_state <= gera_trig;
						ELSIF (E_SINAL_TRIG = '0') THEN
							nx_state <= espera_echo;
						END IF;

						
						
					WHEN espera_echo =>
						S_RST_ECHO <= '1';

						IF (E_SINAL_ECHO = '0') THEN
							nx_state <= espera_echo;
						ELSIF (E_SINAL_ECHO = '1') THEN
							nx_state <= mede_echo;
						END IF;

						
						
					WHEN mede_echo =>
						S_RST_ECHO <= '0';

						IF (E_SINAL_ECHO = '1') THEN
							nx_state <= mede_echo;
						ELSIF (E_SINAL_ECHO = '0') THEN
							nx_state <= inicia_delay;
						END IF;

						
						
					WHEN inicia_delay =>
						S_EN_DELAY <= '1';
						
						IF (E_SINAL_DELAY = '0') THEN
							nx_state <= inicia_delay;
						ELSIF (E_SINAL_DELAY = '1') THEN
							nx_state <= delay;
						END IF;

						
					WHEN delay =>
					
						IF (E_SINAL_DELAY = '1') THEN
							nx_state <= delay;
						ELSIF (E_SINAL_DELAY = '0') THEN
							nx_state <= inicio;
						END IF;

						
				END CASE;	
		END PROCESS;
END HARDWARE;


