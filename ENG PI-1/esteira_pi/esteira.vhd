-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-----------------------------------------
ENTITY esteira IS
    PORT(
	    KEY : IN STD_LOGIC_VECTOR (3 DOWNTO 0)
		);
END esteira;
-----------------------------------------
ARCHITECTURE BOTOES OF esteira IS
	SIGNAL MENU: INTEGER RANGE 0 TO 3;
    SIGNAL ALTURA: INTEGER RANGE 0 TO 10; -- a definir alturas
    SIGNAL COR: INTEGER RANGE 0 TO 3;
    SIGNAL PESO: INTEGER RANGE 0 TO 10; -- a definir pesos
	BEGIN
	
    PROCESS (KEY3) 
    		IF (KEY3'EVENT AND KEY3 = '0') THEN        
    			MENU <= MENU + 1; --selecao de menu
    			IF (MENU = 4) THEN
    				MENU <= 0;
    			END IF;
    		END IF; 
    		
    		IF (MENU = '0') THEN 
    		    --codigo pra exibir a tela inicial
    		END IF;		
	END PROCESS;
	
	PROCESS (KEY2)
		BEGIN
		IF (KEY2'EVENT AND KEY2 = '0') THEN 
			
			CASE MENU IS
				WHEN 0 => 
				WHEN 1 => ALTURA <= ALTURA + 1;
				WHEN 2 => COR <= COR + 1;
				WHEN 3 => PESO <= PESO + 1;
			END CASE;
			
			IF (ALTURA = 11) THEN ALTURA <= 0;
			END IF;
			
			IF (COR = 4) THEN COR <= 0;
			END IF;
			
			IF (PESO = 11) THEN PESO <= 0;
			END IF;
		
		END IF;	
	END PROCESS;
	
	PROCESS (KEY1)
		BEGIN
		IF (KEY1'EVENT AND KEY1 = '0') THEN 
			
			CASE MENU IS
				WHEN 0 => 
				WHEN 1 => ALTURA <= ALTURA - 1;
				WHEN 2 => COR <= COR - 1;
				WHEN 3 => PESO <= PESO - 1;
			END CASE;
			
			IF (ALTURA = 0) THEN ALTURA <= 10;
			END IF;
			
			IF (COR = 0) THEN COR <= 3;
			END IF;
			
			IF (PESO = 0) THEN PESO <= 10;
			END IF;
		
		END IF;	
	END PROCESS;	
	
END BOTOES;
