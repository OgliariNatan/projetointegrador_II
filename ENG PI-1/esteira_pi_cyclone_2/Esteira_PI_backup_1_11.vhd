-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;  ---
-----------------------------------------
ENTITY Esteira_PI IS
  GENERIC(freqIn			  : INTEGER := 50000000;
				  delay				  : INTEGER := 100;
	        defaultState	: STD_LOGIC := '0'
	        );

  PORT (KEY        : IN     STD_LOGIC_VECTOR (3 DOWNTO 0);
        CLOCK_50   : IN     STD_LOGIC;
        LCD_DATA   : OUT    STD_LOGIC_VECTOR (7 DOWNTO 0);
        LCD_EN     : OUT    STD_LOGIC;
        LCD_RW     : OUT    STD_LOGIC;
        LCD_RS     : OUT    STD_LOGIC;
        LCD_ON     : OUT    STD_LOGIC;
        LCD_BLON   : OUT    STD_LOGIC;
        HC_trigger : OUT    STD_LOGIC;
        HC_echo    : IN     STD_LOGIC
        );

END Esteira_PI;
----------------------------------------
ARCHITECTURE object_picker OF Esteira_PI IS
  SIGNAL clock_10kHz: STD_LOGIC; -- T = 100us
  SIGNAL clock_10Mhz: STD_LOGIC; -- T = 0.1us

  SIGNAL lcd_state      : INTEGER RANGE 0 TO 10 := 1;
  SIGNAL cor_set        : INTEGER RANGE 0 TO 3 := 0;              -- cor setada
  SIGNAL cor_med        : INTEGER RANGE 0 TO 3 := 2;              -- cor medida
  SIGNAL pos_set        : STD_LOGIC_VECTOR (7 DOWNTO 0) := X"CD"; -- cursor LDC

  SIGNAL altura_set     : INTEGER RANGE 0 TO 999 := 123;          -- altura setada
  SIGNAL altura_set_c_ascii   : INTEGER RANGE 47 TO 58;                  -- altura setada: centena
  SIGNAL altura_set_d_ascii   : INTEGER RANGE 47 TO 58;                  -- altura setada: dezena
  SIGNAL altura_set_u_ascii   : INTEGER RANGE 47 TO 58;                  -- altura setada: unidade
  SIGNAL altura_set_c_lcd   : INTEGER RANGE 0 TO 9;                  -- altura setada: centena
  SIGNAL altura_set_d_lcd   : INTEGER RANGE 0 TO 9;                  -- altura setada: dezena
  SIGNAL altura_set_u_lcd   : INTEGER RANGE 0 TO 9;                  -- altura setada: unidade

  SIGNAL peso_set         : INTEGER RANGE 0 TO 999 := 456;
  SIGNAL peso_set_c_ascii   : INTEGER RANGE 47 TO 58;                  -- altura setada: centena
  SIGNAL peso_set_d_ascii   : INTEGER RANGE 47 TO 58;                  -- altura setada: dezena
  SIGNAL peso_set_u_ascii   : INTEGER RANGE 47 TO 58;                  -- altura setada: unidade
  SIGNAL peso_set_c_lcd   : INTEGER RANGE 0 TO 9;                  -- altura setada: centena
  SIGNAL peso_set_d_lcd   : INTEGER RANGE 0 TO 9;                  -- altura setada: dezena
  SIGNAL peso_set_u_lcd   : INTEGER RANGE 0 TO 9;                  -- altura setada: unidade

  SIGNAL altura_m       : INTEGER RANGE 0 TO 999 := 789;
  SIGNAL altura_aux       : INTEGER RANGE 0 TO 999;
  SIGNAL altura_mc      : INTEGER RANGE 0 TO 60;
  SIGNAL altura_md      : INTEGER RANGE 0 TO 60;
  SIGNAL altura_mu      : INTEGER RANGE 0 TO 60;
  SIGNAL altura_adj     : INTEGER RANGE 0 TO 999 := 0;

  SIGNAL peso_m         : INTEGER RANGE 0 TO 999 := 987;
  SIGNAL peso_mc        : INTEGER RANGE 0 TO 60;
  SIGNAL peso_md        : INTEGER RANGE 0 TO 60;
  SIGNAL peso_mu        : INTEGER RANGE 0 TO 60;

  CONSTANT CONT_MAX		  : INTEGER := ((freqIn/ 1000) * delay) - 1; --- botao

  SIGNAL buttonAux0		  : STD_LOGIC := '0';
  SIGNAL buttonPressed0	: STD_LOGIC := '0';
  SIGNAL buttonOut0	    : STD_LOGIC := '0';

  SIGNAL buttonAux1		  : STD_LOGIC := '0';
  SIGNAL buttonPressed1	: STD_LOGIC := '0';
  SIGNAL buttonOut1	    : STD_LOGIC := '0';

  SIGNAL buttonAux2		  : STD_LOGIC := '0';
  SIGNAL buttonPressed2	: STD_LOGIC := '0';
  SIGNAL buttonOut2	    : STD_LOGIC := '0';

  SIGNAL buttonAux3		  : STD_LOGIC := '0';
  SIGNAL buttonPressed3	: STD_LOGIC := '0';
  SIGNAL buttonOut3	    : STD_LOGIC := '0';

  SIGNAL menu_set       : INTEGER RANGE 0 TO 3;
  SIGNAL flag_m0        : STD_LOGIC;
  SIGNAL flag_m1        : STD_LOGIC;
  SIGNAL flag_m2        : STD_LOGIC;
  SIGNAL flag_b0        : STD_LOGIC;
  SIGNAL flag_b1        : STD_LOGIC;
  SIGNAL flag_b2        : STD_LOGIC;

  BEGIN

  altura_set_c_ascii <= altura_set_c_lcd + 48; ---- 48 do ascii
  altura_set_d_ascii <= altura_set_d_lcd + 48;
  altura_set_u_ascii <= altura_set_u_lcd + 48;
  altura_set <= altura_set_c_lcd*100 + altura_set_d_lcd*10 + altura_set_u_lcd;

  peso_set_c_ascii <= peso_set_c_lcd + 48; ---- 48 do ascii
  peso_set_d_ascii <= peso_set_d_lcd + 48;
  peso_set_u_ascii <= peso_set_u_lcd + 48;
  peso_set <= peso_set_c_lcd*100 + peso_set_d_lcd*10 + peso_set_u_lcd;

  altura_mc <= ((altura_m/100) + 48);
  altura_md <= (((altura_m/10) - ((altura_m/100)*10)) + 48);
  altura_mu <= ((altura_m rem 10) + 48);

  peso_mc   <= ((peso_m/100) + 48);
  peso_md   <= (((peso_m/10) - ((peso_m/100)*10)) + 48);
  peso_mu   <= ((peso_m rem 10) + 48);

  LCD_ON    <=    '1';--- remover
  LCD_BLON  <=    '1';--- remover

  buttonAux0 <= KEY(0) WHEN defaultState = '0' ELSE (NOT KEY(0));
  buttonOut0 <= buttonPressed0 WHEN defaultState = '0' ELSE (NOT buttonPressed0);

  buttonAux1 <= KEY(1) WHEN defaultState = '0' ELSE (NOT KEY(1));
  buttonOut1 <= buttonPressed1 WHEN defaultState = '0' ELSE (NOT buttonPressed1);

  buttonAux2 <= KEY(2) WHEN defaultState = '0' ELSE (NOT KEY(2));
  buttonOut2 <= buttonPressed2 WHEN defaultState = '0' ELSE (NOT buttonPressed2);

  buttonAux3 <= KEY(3) WHEN defaultState = '0' ELSE (NOT KEY(3));
  buttonOut3 <= buttonPressed2 WHEN defaultState = '0' ELSE (NOT buttonPressed2);

  PROCESS(CLOCK_50)
    VARIABLE counter : INTEGER RANGE 0 TO CONT_MAX := 0;
  BEGIN
    IF RISING_EDGE(CLOCK_50) THEN
      IF buttonPressed0 = '0' AND buttonAux0 = '1' THEN		-- Primeira vez pressionado
        buttonPressed0 <= '1';
        counter := 0;
      ELSIF buttonPressed0 = '1' AND buttonAux0 = '1' THEN	-- Ainda pressionado
        counter := 0;
      ELSIF buttonPressed0 = '1' AND buttonAux0 = '0' THEN	-- Botao e liberado ou uma trepidacao ocorreu
        IF counter < CONT_MAX THEN
          counter := counter + 1;
        ELSE
          counter := 0;
          buttonPressed0 <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS(CLOCK_50)
    VARIABLE counter : INTEGER RANGE 0 TO CONT_MAX := 0;
  BEGIN
    IF RISING_EDGE(CLOCK_50) THEN
      IF buttonPressed1 = '0' AND buttonAux1 = '1' THEN		-- Primeira vez pressionado
        buttonPressed1 <= '1';
        counter := 0;
      ELSIF buttonPressed1 = '1' AND buttonAux1 = '1' THEN	-- Ainda pressionado
        counter := 0;
      ELSIF buttonPressed1 = '1' AND buttonAux1 = '0' THEN	-- Botao e liberado ou uma trepidacao ocorreu
        IF counter < CONT_MAX THEN
          counter := counter + 1;
        ELSE
          counter := 0;
          buttonPressed1 <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS(CLOCK_50)
    VARIABLE counter : INTEGER RANGE 0 TO CONT_MAX := 0;
  BEGIN
    IF RISING_EDGE(CLOCK_50) THEN
      IF buttonPressed2 = '0' AND buttonAux2 = '1' THEN		-- Primeira vez pressionado
        buttonPressed2 <= '1';
        counter := 0;
      ELSIF buttonPressed2 = '1' AND buttonAux2 = '1' THEN	-- Ainda pressionado
        counter := 0;
      ELSIF buttonPressed2 = '1' AND buttonAux2 = '0' THEN	-- Botao e liberado ou uma trepidacao ocorreu
        IF counter < CONT_MAX THEN
          counter := counter + 1;
        ELSE
          counter := 0;
          buttonPressed2 <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS(CLOCK_50)
    VARIABLE counter : INTEGER RANGE 0 TO CONT_MAX := 0;
  BEGIN
    IF RISING_EDGE(CLOCK_50) THEN
      IF buttonPressed3 = '0' AND buttonAux3 = '1' THEN		-- Primeira vez pressionado
        buttonPressed3 <= '1';
        counter := 0;
      ELSIF buttonPressed3 = '1' AND buttonAux3 = '1' THEN	-- Ainda pressionado
        counter := 0;
      ELSIF buttonPressed3 = '1' AND buttonAux3 = '0' THEN	-- Botao e liberado ou uma trepidacao ocorreu
        IF counter < CONT_MAX THEN
          counter := counter + 1;
        ELSE
          counter := 0;
          buttonPressed3 <= '0';
        END IF;
      END IF;
    END IF;
  END PROCESS;

  PROCESS(buttonOut0)
  BEGIN
		IF FALLING_EDGE(buttonOut0) THEN
      flag_b0 <= '1';
    END IF;
    IF (flag_m0 = '1') THEN
      flag_b0 <= '0';
    END IF;
  END PROCESS;

  PROCESS(buttonOut1)
	BEGIN
		IF FALLING_EDGE(buttonOut1) THEN
      flag_b1 <= '1';
    END IF;
    IF (flag_m1 = '1') THEN
      flag_b1 <= '0';
    END IF;
  END PROCESS;

  PROCESS(buttonOut2)
	BEGIN
		IF FALLING_EDGE(buttonOut2) THEN
      flag_b2 <= '1';
    END IF;
    IF (flag_m2 = '1') THEN
      flag_b2 <= '0';
    END IF;
  END PROCESS;

  PROCESS(clock_10kHz)
  VARIABLE count : INTEGER RANGE 0 TO 10000 := 0;
	BEGIN
    IF (rising_edge(clock_10kHz)) THEN

      IF (flag_b0 = '0') THEN
        flag_m0 <= '0';
      END IF;

      IF (flag_b1 = '0') THEN
        flag_m1 <= '0';
      END IF;

      IF (flag_b2 = '0') THEN
        flag_m2 <= '0';
      END IF;

      IF (flag_b0 = '1') THEN
        IF (KEY(0) = '0') THEN
          count := count + 1;
          IF (count = 9999) THEN
            altura_adj <= altura_aux;
            count := 0;
          END IF;
        ELSE
          flag_m0 <= '1';
          menu_set <= menu_set + 1;
        END IF;
      END IF;

      IF (flag_b1 = '1') THEN
        IF (KEY(1) = '0') THEN
          count := count + 1;
          IF (count = 9999) THEN
            CASE menu_set IS
              WHEN 1 => cor_set <= cor_set + 1;
              WHEN 2 => IF (altura_set_d_lcd = 9) THEN
                          altura_set_d_lcd <= 0;
                          IF (altura_set_c_lcd = 9) THEN
                            altura_set_c_lcd <= 0;
                          ELSE
                            altura_set_c_lcd <= altura_set_c_lcd + 1;
                          END IF;
                        ELSE
                          altura_set_d_lcd <= altura_set_d_lcd + 1;
                        END IF;
              WHEN 3 => IF (peso_set_d_lcd = 9) THEN
                          peso_set_d_lcd <= 0;
                          IF (peso_set_c_lcd = 9) THEN
                            peso_set_c_lcd <= 0;
                          ELSE
                            peso_set_c_lcd <= peso_set_c_lcd + 1;
                          END IF;
                        ELSE
                          peso_set_d_lcd <= peso_set_d_lcd + 1;
                        END IF;
              WHEN OTHERS => NULL;
            END CASE;
            count := 0;
          END IF;
        ELSE
          flag_m1 <= '1';
          CASE menu_set IS
              WHEN 1 => cor_set <= cor_set + 1;
              WHEN 2 => IF (altura_set_u_lcd = 9) THEN
                          altura_set_u_lcd <= 0;
                          IF (altura_set_d_lcd = 9) THEN
                            altura_set_d_lcd <= 0;
                            IF (altura_set_c_lcd = 9) THEN
                              altura_set_c_lcd <= 0;
                            ELSE
                              altura_set_c_lcd <= altura_set_c_lcd + 1;
                            END IF;
                          ELSE
                            altura_set_d_lcd <= altura_set_d_lcd + 1;
                          END IF;
                        ELSE
                          altura_set_u_lcd <= altura_set_u_lcd + 1;
                        END IF;
              WHEN 3 => IF (peso_set_u_lcd = 9) THEN
                          peso_set_u_lcd <= 0;
                          IF (peso_set_d_lcd = 9) THEN
                            peso_set_d_lcd <= 0;
                            IF (peso_set_c_lcd = 9) THEN
                              peso_set_c_lcd <= 0;
                            ELSE
                              peso_set_c_lcd <= peso_set_c_lcd + 1;
                            END IF;
                          ELSE
                            peso_set_d_lcd <= peso_set_d_lcd + 1;
                          END IF;
                        ELSE
                          peso_set_u_lcd <= peso_set_u_lcd + 1;
                        END IF;
              WHEN OTHERS => NULL;
            END CASE;
        END IF;
      END IF;

      IF (flag_b2 = '1') THEN
        IF (KEY(2) = '0') THEN
          count := count + 1;
          IF (count = 9999) THEN
            CASE menu_set IS
              WHEN 1 => cor_set <= cor_set - 1;
              WHEN 2 => IF (altura_set_d_lcd = 0) THEN
                          altura_set_d_lcd <= 9;
                          IF (altura_set_c_lcd = 0) THEN
                            altura_set_c_lcd <= 9;
                          ELSE
                            altura_set_c_lcd <= altura_set_c_lcd - 1;
                          END IF;
                        ELSE
                          altura_set_d_lcd <= altura_set_d_lcd - 1;
                        END IF;
              WHEN 3 => IF (peso_set_d_lcd = 0) THEN
                          peso_set_d_lcd <= 9;
                          IF (peso_set_c_lcd = 0) THEN
                            peso_set_c_lcd <= 9;
                          ELSE
                            peso_set_c_lcd <= peso_set_c_lcd - 1;
                          END IF;
                        ELSE
                          peso_set_d_lcd <= peso_set_d_lcd - 1;
                        END IF;
              WHEN OTHERS => NULL;
            END CASE;
            count := 0;
          END IF;
        ELSE
          flag_m2 <= '1';
          CASE menu_set IS
              WHEN 1 => cor_set <= cor_set - 1;
              WHEN 2 => IF (altura_set_u_lcd = 0) THEN
                          altura_set_u_lcd <= 9;
                          IF (altura_set_d_lcd = 0) THEN
                            altura_set_d_lcd <= 9;
                            IF (altura_set_c_lcd = 0) THEN
                              altura_set_c_lcd <= 9;
                            ELSE
                              altura_set_c_lcd <= altura_set_c_lcd - 1;
                            END IF;
                          ELSE
                            altura_set_d_lcd <= altura_set_d_lcd - 1;
                          END IF;
                        ELSE
                          altura_set_u_lcd <= altura_set_u_lcd - 1;
                        END IF;
              WHEN 3 => IF (peso_set_u_lcd = 0) THEN
                          peso_set_u_lcd <= 9;
                          IF (peso_set_d_lcd = 0) THEN
                            peso_set_d_lcd <= 9;
                            IF (peso_set_c_lcd = 0) THEN
                              peso_set_c_lcd <= 9;
                            ELSE
                              peso_set_c_lcd <= peso_set_c_lcd - 1;
                            END IF;
                          ELSE
                            peso_set_d_lcd <= peso_set_d_lcd - 1;
                          END IF;
                        ELSE
                          peso_set_u_lcd <= peso_set_u_lcd - 1;
                        END IF;
              WHEN OTHERS => NULL;
            END CASE;
        END IF;
      END IF;

    END IF;
  END PROCESS;


-----------------------sensor ultrassonico----------------------------|
  PROCESS (clock_10Mhz)
    variable count        :   INTEGER RANGE 0 TO 5000000;
    variable time_trigger :   INTEGER RANGE 0 TO 10000001;

  BEGIN

    IF (rising_edge(CLOCK_50)) THEN    --verificar CLOCK_50
      IF (time_trigger < 10000000) THEN --era pra ser 1s
        time_trigger := time_trigger + 1;
      ELSE
        time_trigger := 0;
      END IF;

      IF (time_trigger = 0) THEN ---- fica 550 ciclos * 50MHz em alto, mas era para ser 10mhz
        HC_trigger <= '1';
      END IF;
      IF (time_trigger = 550) THEN
        HC_trigger <= '0';
      END IF;

      IF (HC_echo='1') THEN
        count := count + 1;
      ELSE
        IF (count > 0) THEN
          altura_aux <= ((count*34000)/10000000);
          
          altura_m <= altura_aux - altura_adj;
          
--          IF (altura_aux >= altura_m ) THEN
--            altura_m <= altura_aux - altura_adj;
--          ELSE
--            altura_m <= altura_adj - altura_aux;
--          END IF;
          count := 0;
        END IF;
      END IF;
    END IF;
  END PROCESS;
----------------------------------------------------------------------|

----------------------------------------------------------|
---------------------Divisor de clock---------------------|
  PROCESS (CLOCK_50)                                    --| Divisor de clock para 20khz
    variable count100us  :  INTEGER RANGE 0 TO 2501;    --| Periodo de 50us
    variable count100ns  :  INTEGER RANGE 0 TO 10;      --|
    --                                                  --|
  BEGIN                                                 --|
    --                                                  --|
    IF (rising_edge(CLOCK_50)) THEN                     --|
      count100us := count100us + 1;                     --|
      count100ns := count100ns + 1;                     --|
      IF (count100us = 2500) THEN                       --|
        clock_10kHz <= NOT clock_10kHz;                 --|
        count100us := 0;                                --|
      END IF;                                           --|
      IF (count100ns = 5) THEN                          --| Divisor de clock para 10Mhz
        clock_10Mhz <= NOT clock_10Mhz;                 --| Periodo de 100ns
        count100ns := 0;                                --|
      END IF;                                           --|
    END IF;                                             --|
    --                                                  --|
  END PROCESS;                                          --|
----------------------------------------------------------|


---------------------------------------------------------------------------------------
-------------------------- MAQUINA DE ESTADOS LCD --------------------------------------
  lcd_process : PROCESS
    VARIABLE auxtemp    : INTEGER RANGE 0 TO 2000 :=0;
    VARIABLE auxcount   : INTEGER RANGE 0 TO 1;
    VARIABLE test       : INTEGER RANGE 0 TO 2000 :=0;
    BEGIN

      wait until rising_edge(clock_10kHz);

      IF (auxcount=1) THEN
        auxtemp := auxtemp + 1;
      END IF;

    CASE lcd_state IS

-- Case 0 = idle                         --|
-- Case 1 = Init 1                       --|
-- Case 2 = Init 2                       --|
-- Case 3 = Cor set    -- Liga o blink   --|
-- Case 4 = Altura set -- Liga o blink   --|
-- Case 5 = Peso set   -- Liga o blink   --|
-- Case 6 = Desliga o blink              --|
-- Case 7 = Atualiza cor medida          --|
-- Case 8 = Atualiza peso medido         --|
-- Case 9 = Atualiza altura medida       --|

      ------------------Idle state and verify change value set--------------|

      WHEN 0 =>
        CASE auxtemp IS
          WHEN 1000 =>
            CASE menu_set IS
              WHEN 0 => lcd_state <= 6;
                        auxtemp   := 0;
              WHEN 1 => lcd_state <= 3;
                        auxtemp   := 0;
              WHEN 2 => lcd_state <= 4;
                        auxtemp   := 0;
              WHEN 3 => lcd_state <= 5;
                        auxtemp   := 0;
              WHEN OTHERS => NULL;
            END CASE;
          WHEN OTHERS =>
--          auxtemp   :=  0 ;
          auxcount  :=  1 ;
          LCD_DATA  <= "00000000";
          LCD_RS    <= '0';
          LCD_RW    <= '0';
          LCD_EN    <= '0';
        END CASE;

      ----------------------------------------------------------------------|
      ------------------Init 1 state----------------------------------------|
      WHEN 1 =>                                                           --|
        CASE auxtemp IS                                                   --|
                                                                          --|
          -------------Passo 1, 50ms--------------| Init                  --|
          WHEN 0    =>  auxcount :=  1 ;        --|                       --|
          WHEN 1    =>  auxcount :=  1 ;        --|                       --|
                        LCD_DATA <= "00110000"; --|                       --|
                        LCD_RS  <=  '0';        --|                       --|
                        LCD_RW  <=  '0';        --|                       --|
                        LCD_EN   <=  '0';       --|                       --|
                        --                      --|                       --|
          WHEN 1000 =>   LCD_EN  <= '1';        --|                       --|
          WHEN 1001 =>   LCD_EN  <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 2, 5ms---------------| Init                  --|
          WHEN 1100 =>  LCD_EN  <= '1';         --|                       --|
          WHEN 1101 =>  LCD_EN  <= '0';         --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 3, 100us-------------| Init                  --|
          WHEN 1103 =>  LCD_EN  <= '1';         --|                       --|
          WHEN 1104 =>  LCD_EN  <= '0';         --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 4--------------------| Define 8bits lcd_DATA --|
          WHEN 1105 =>  LCD_DATA <= "00110000"; --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 1107 =>   LCD_EN   <= '0';       --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 5--------------------| Define 2 line         --|
          WHEN 1108 =>  LCD_DATA <= "00111000"; --| and character 5x8     --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 1110 =>   LCD_EN   <= '0';       --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 6--------------------| Display off           --|
          WHEN 1111 =>  LCD_DATA <= "00001000"; --|                       --|
                        LCD_EN  <= '1';         --|                       --|
          WHEN 1113 =>  LCD_EN  <= '0';         --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 7--------------------| Clear display         --|
          WHEN 1114 =>  LCD_DATA <= "00000001"; --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 1116 =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 8--------------------| Entry set mode        --|
          WHEN 1217 =>  LCD_DATA <= "00000110"; --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 1219 =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Passo 9--------------------| Display on            --|
          WHEN 1220 =>  LCD_DATA <= "00001100"; --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 1222 =>  auxtemp  :=  0 ;        --| Encerra inicialização --|
                        auxcount :=  0 ;        --|                       --|
                        LCD_DATA <= "00000000"; --|                       --|
                        LCD_RS   <=  '0';       --|                       --|
                        LCD_RW   <=  '0';       --|                       --|
                        LCD_EN   <= '0';        --|                       --|
                        lcd_state<=  2 ;        --|  --lcd_state<=0;--    --|
                        auxtemp  :=  0 ;        --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS => NULL;                                            --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|



      ------------------Init 2 state----------------------------------------|
      WHEN 2 =>                                                           --|
        CASE auxtemp IS                                                   --|
                                                                          --|
          -------------Clear Display--------------|                       --|
          WHEN 0    =>  auxcount :=  1 ;        --|                       --|
          WHEN 1    =>  auxcount :=  1 ;        --|                       --|
                        LCD_DATA <= "00000001"; --|                       --|
                        LCD_RS   <= '0';        --|                       --|
                        LCD_RW   <= '0';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 2    =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra V----------|                       --|
          WHEN 101  =>  LCD_DATA <= X"56";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 102  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra a----------|                       --|
          WHEN 103  =>  LCD_DATA <= X"61";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 104  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra l----------|                       --|
          WHEN 105  =>  LCD_DATA <= X"6C";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 106  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra o----------|                       --|
          WHEN 107  =>  LCD_DATA <= X"6F";      --|                       --|
                        LCD_EN  <= '1';         --|                       --|
          WHEN 108  =>  LCD_EN  <= '0';         --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra r----------|                       --|
          WHEN 109  =>  LCD_DATA <= X"72";      --|                       --|
                        LCD_EN  <= '1';         --|                       --|
          WHEN 110  =>  LCD_EN  <= '0';         --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra e----------|                       --|
          WHEN 111  =>  LCD_DATA <= X"65";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 112  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra s----------|                       --|
          WHEN 113  =>  LCD_DATA <= X"73";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 114  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime um espaco----------|                       --|
          WHEN 115  =>  LCD_DATA <= X"20";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 116  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra S----------|                       --|
          WHEN 117  =>  LCD_DATA <= X"53";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 118  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra e----------|                       --|
          WHEN 119  =>  LCD_DATA <= X"65";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 120  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra t----------|                       --|
          WHEN 121  =>  LCD_DATA <= X"74";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 122  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime um ponto-----------|                       --|
          WHEN 123  =>  LCD_DATA <= X"2E";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 124  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime um espaco----------|                       --|
          WHEN 125  =>  LCD_DATA <= X"20";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 126  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra M----------|                       --|
          WHEN 127  =>  LCD_DATA <= X"4D";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 128  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra e----------|                       --|
          WHEN 129  =>  LCD_DATA <= X"65";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 130  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra d----------|                       --|
          WHEN 131  =>  LCD_DATA <= X"64";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 132  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime um ponto-----------|                       --|
          WHEN 133  =>  LCD_DATA <= X"2E";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 134  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime um espaco----------|                       --|
          WHEN 135  =>  LCD_DATA <= X"20";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 136  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra U----------|                       --|
          WHEN 137  =>  LCD_DATA <= X"55";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 138  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra n----------|                       --|
          WHEN 139  =>  LCD_DATA <= X"6E";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 140  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set line write-------------|                       --|
          WHEN 141  =>  LCD_DATA <= X"C0";      --| --X"80" 1line         --|
                        auxcount :=  1 ;        --| --X"C0" 2line         --|
                        LCD_RS   <= '0';        --| --X"94" 3line         --|
                        LCD_RW   <= '0';        --| --X"D4" 4line         --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 142  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra C----------|                       --|
          WHEN 143  =>  LCD_DATA <= X"43";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 144  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra o----------|                       --|
          WHEN 145  =>  LCD_DATA <= X"6F";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 146  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra r----------|                       --|
          WHEN 147  =>  LCD_DATA <= X"72";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 148  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime dois pontos ":"----|                       --|
          WHEN 149  =>  LCD_DATA <= X"3A";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 150  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set line write-------------|                       --|
          WHEN 151  =>  LCD_DATA <= X"94";      --| --X"80" 1line         --|
                        auxcount :=  1 ;        --| --X"C0" 2line         --|
                        LCD_RS   <= '0';        --| --X"94" 3line         --|
                        LCD_RW   <= '0';        --| --X"D4" 4line         --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 152  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra A----------|                       --|
          WHEN 153  =>  LCD_DATA <= X"41";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 154  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra l----------|                       --|
          WHEN 155  =>  LCD_DATA <= X"6C";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 156  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra t----------|                       --|
          WHEN 157  =>  LCD_DATA <= X"74";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 158  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra u----------|                       --|
          WHEN 159  =>  LCD_DATA <= X"75";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 160  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra r----------|                       --|
          WHEN 161  =>  LCD_DATA <= X"72";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 162  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra a----------|                       --|
          WHEN 163  =>  LCD_DATA <= X"61";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 164  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime dois pontos ":"----|                       --|
          WHEN 165  =>  LCD_DATA <= X"3A";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 166  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set line write-------------|                       --|
          WHEN 167  =>  LCD_DATA <= X"D4";      --| --X"80" 1line         --|
                        auxcount :=  1 ;        --| --X"C0" 2line         --|
                        LCD_RS   <= '0';        --| --X"94" 3line         --|
                        LCD_RW   <= '0';        --| --X"D4" 4line         --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 168  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra P----------|                       --|
          WHEN 169  =>  LCD_DATA <= X"50";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 170  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra e----------|                       --|
          WHEN 171  =>  LCD_DATA <= X"65";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 172  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra s----------|                       --|
          WHEN 173  =>  LCD_DATA <= X"73";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 174  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra o----------|                       --|
          WHEN 175  =>  LCD_DATA <= X"6F";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 176  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime dois pontos ":"----|                       --|
          WHEN 177  =>  LCD_DATA <= X"3A";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 178  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 179  =>  LCD_DATA <= X"A6";      --|                       --|
                        LCD_RS   <= '0';        --|                       --|
                        LCD_RW   <= '0';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 180  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra c----------|                       --|
          WHEN 181  =>  LCD_DATA <= X"63";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 182  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra m----------|                       --|
          WHEN 183  =>  LCD_DATA <= X"6D";      --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 184  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 185  =>  LCD_DATA <= X"E7";      --|                       --|
                        LCD_RS   <= '0';        --|                       --|
                        LCD_RW   <= '0';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 186  =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime a letra g----------|                       --|
          WHEN 187  =>  LCD_DATA <= X"67";      --|                       --|
                        LCD_RS   <= '1';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 188  =>  LCD_EN   <= '0';        --|                       --|
                        LCD_state<=  0 ;        --|  --lcd_state<=0;--    --|
                        auxtemp  :=  0 ;        --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS => NULL;                                            --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|



      ------------------Cor set state---------------------------------------|
      WHEN 3 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 00   =>  auxcount :=  1 ;        --|                       --|
          WHEN 01   =>  auxcount :=  1 ;        --|                       --|
                        LCD_DATA <= X"C8";      --|                       --|
                        LCD_RS   <= '0';        --|                       --|
                        LCD_RW   <= '0';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
                        pos_set  <= X"C8";      --|                       --|
          WHEN 02   =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Blink on-------------------|                       --|
          WHEN 03   =>  LCD_DATA <= "00001101"; --|                       --|
                        LCD_RS   <= '0';        --|                       --|
                        LCD_RW   <= '0';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 04   =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Escreve a cor---------------|                      --|
          WHEN OTHERS =>                         --|                      --|
            CASE cor_set IS                      --|                      --|
              --                                 --|                      --|
              -------------Desativado-------------||                      --|
              WHEN 0 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra D-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"44";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra s-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"73";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra t-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"74";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra v-----|||                      --|
                  WHEN 11 => LCD_DATA <= X"76";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 13 => LCD_DATA <= X"C8";--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 14 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  7 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              --                                 --|                      --|
              -------------Vermelho---------------||                      --|
              WHEN 1 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra V-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"56";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra e-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"65";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra r-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"72";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra m-----|||                      --|
                  WHEN 11 => LCD_DATA <= X"6D";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 13 => LCD_DATA <= X"C8";--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 14 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  7 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              --                                 --|                      --|
              -------------Verde------------------||                      --|
              WHEN 2 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra V-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"56";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra e-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"65";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra r-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"72";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra d-----|||                      --|
                  WHEN 11 => LCD_DATA <= X"64";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 13 => LCD_DATA <= X"C8";--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 14 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  7 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              --                                 --|                      --|
              -------------Azul-------------------||                      --|
              WHEN 3 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra A-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"41";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra z-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"7A";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra u-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"75";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra l-----|||                      --|
                  WHEN 11 => LCD_DATA <= X"6C";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 13 => LCD_DATA <= X"C8";--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 14 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  7 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              WHEN OTHERS => NULL;               --|                      --|
            END CASE;                            --|                      --|
            ---------------------------------------|                      --|
        END CASE;                                                         --|
        --------------------------------------------------------------------|



      ------------------Altura set state------------------------------------|
      WHEN 4 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 00 => auxcount :=  1 ;           --|                       --|
          WHEN 01 => auxcount :=  1 ;           --|                       --|
                     LCD_DATA <= X"9C";         --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
                     pos_set  <= X"9C";         --|                       --|
          WHEN 02 => LCD_EN   <= '0';           --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Blink on-------------------|                       --|
          WHEN 03 => LCD_DATA <= "00001101";    --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
          WHEN 04 => LCD_EN   <= '0';           --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero c---------|                       --|
          WHEN 05 => LCD_DATA<= std_logic_vector(to_unsigned(altura_set_c_ascii, LCD_DATA'length));
                     LCD_RS  <= '1';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 06 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero d---------|                       --|
          WHEN 07 => LCD_DATA <= std_logic_vector(to_unsigned(altura_set_d_ascii, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 08 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime ponto--------------|                       --|
          WHEN 09 => LCD_DATA <= X"2E";         --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 10 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero u---------|                       --|
          WHEN 11 => LCD_DATA <= std_logic_vector(to_unsigned(altura_set_u_ascii, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 12 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 13 => LCD_DATA <= X"9C";         --|                       --|
                     LCD_RS  <= '0';            --|                       --|
                     LCD_RW  <= '0';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 14 => LCD_EN  <= '0';            --|                       --|
                     lcd_state<= 7 ;            --|                       --|
                     auxtemp :=  0 ;            --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS =>  NULL;                                           --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|



      ------------------Peso set state--------------------------------------|
      WHEN 5 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 00 => auxcount :=  1 ;           --|                       --|
          WHEN 01 => auxcount :=  1 ;           --|                       --|
                     LCD_DATA <= X"DC";         --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
                     pos_set  <= X"DC";         --|                       --|
          WHEN 02 => LCD_EN   <= '0';           --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Blink on-------------------|                       --|
          WHEN 03 => LCD_DATA <= "00001101";    --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
          WHEN 04 => LCD_EN   <= '0';           --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero c---------|                       --|
          WHEN 05 => LCD_DATA<= std_logic_vector(to_unsigned(peso_set_c_ascii, LCD_DATA'length));
                     LCD_RS  <= '1';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 06 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero d---------|                       --|
          WHEN 07 => LCD_DATA<= std_logic_vector(to_unsigned(peso_set_d_ascii, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 08 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime ponto--------------|                       --|
          WHEN 09 => LCD_DATA<= X"2E";          --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 10 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero u---------|                       --|
          WHEN 11 => LCD_DATA <= std_logic_vector(to_unsigned(peso_set_u_ascii, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 12 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 13 => LCD_DATA<= X"DC";          --|                       --|
                     LCD_RS  <= '0';            --|                       --|
                     LCD_RW  <= '0';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 14 => LCD_EN  <= '0';            --|                       --|
                     lcd_state<= 7 ;            --|                       --|
                     auxtemp :=  0 ;            --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS =>  NULL;                                           --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|



      ------------------Blink off state-------------------------------------|
      WHEN 6 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Blink off------------------|                       --|
          WHEN 00 => auxcount :=  1 ;           --|                       --|
          WHEN 01 => auxcount :=  1 ;           --|                       --|
                     LCD_DATA <= "00001100";    --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
          WHEN 02 => LCD_EN   <= '0';           --|                       --|
                     lcd_state<=  7 ;           --|                       --|
                     auxtemp  :=  0 ;           --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS =>  NULL;                                           --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|



      ------------------Cor med state---------------------------------------|
      WHEN 7 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 00   =>  auxcount :=  1 ;        --|                       --|
          WHEN 01   =>  auxcount :=  1 ;        --|                       --|
                        LCD_DATA <= X"CD";      --|                       --|
                        LCD_RS   <= '0';        --|                       --|
                        LCD_RW   <= '0';        --|                       --|
                        LCD_EN   <= '1';        --|                       --|
          WHEN 02   =>  LCD_EN   <= '0';        --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Escreve a cor---------------|                      --|
          WHEN OTHERS =>                         --|                      --|
            CASE cor_med IS                      --|                      --|
              --                                 --|                      --|
              -------------Desativado-------------||                      --|
              WHEN 0 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra D-----|||                      --|
                  WHEN 03 => LCD_DATA <= X"44";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 04 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra s-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"73";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra t-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"74";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra v-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"76";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 11 => LCD_DATA<=pos_set;--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  8 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              --                                 --|                      --|
              -------------Vermelho---------------||                      --|
              WHEN 1 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra V-----|||                      --|
                  WHEN 03 => LCD_DATA <= X"56";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 04 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra e-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"65";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra r-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"72";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra m-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"6D";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 11 => LCD_DATA<=pos_set;--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  8 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              --                                 --|                      --|
              -------------Verde------------------||                      --|
              WHEN 2 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra V-----|||                      --|
                  WHEN 03 => LCD_DATA <= X"56";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 04 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra e-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"65";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra r-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"72";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra d-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"64";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 11 => LCD_DATA<=pos_set;--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  8 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              --                                 --|                      --|
              -------------Azul-------------------||                      --|
              WHEN 3 =>                         --||                      --|
                CASE auxtemp IS                 --||                      --|
                                                --||                      --|
                  ---------Imprime a letra A-----|||                      --|
                  WHEN 03 => LCD_DATA <= X"41";--|||                      --|
                             LCD_RS   <= '1';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 04 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra z-----|||                      --|
                  WHEN 05 => LCD_DATA <= X"7A";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 06 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra u-----|||                      --|
                  WHEN 07 => LCD_DATA <= X"75";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 08 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Imprime a letra l-----|||                      --|
                  WHEN 09 => LCD_DATA <= X"6C";--|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 10 => LCD_EN   <= '0';  --|||                      --|
                  -------------------------------|||                      --|
                  --                              ||                      --|
                  ---------Set ddram-------------|||                      --|
                  WHEN 11 => LCD_DATA<=pos_set;--|||                      --|
                             LCD_RS   <= '0';  --|||                      --|
                             LCD_RW   <= '0';  --|||                      --|
                             LCD_EN   <= '1';  --|||                      --|
                  WHEN 12 => LCD_EN   <= '0';  --|||                      --|
                             lcd_state<=  8 ;  --|||                      --|
                             auxtemp  :=  0 ;  --|||                      --|
                  -------------------------------|||                      --|
                  WHEN OTHERS => NULL;          --||                      --|
                END CASE;                       --||                      --|
              ------------------------------------||                      --|
              WHEN OTHERS => lcd_state <= 0;     --|                      --|
            END CASE;                            --|                      --|
            ---------------------------------------|                      --|
        END CASE;                                                         --|
        --------------------------------------------------------------------|


      ------------------Altura set state------------------------------------|
      WHEN 8 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 00 => auxcount :=  1 ;           --|                       --|
          WHEN 01 => auxcount :=  1 ;           --|                       --|
                     LCD_DATA <= X"A1";         --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
          WHEN 02 => LCD_EN   <= '0';           --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero c---------|                       --|
          WHEN 03 => LCD_DATA<= std_logic_vector(to_unsigned(altura_mc, LCD_DATA'length));
                     LCD_RS  <= '1';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 04 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero d---------|                       --|
          WHEN 05 => LCD_DATA <= std_logic_vector(to_unsigned(altura_md, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 06 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime ponto--------------|                       --|
          WHEN 07 => LCD_DATA <= X"2E";         --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 08 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero u---------|                       --|
          WHEN 09 => LCD_DATA <= std_logic_vector(to_unsigned(altura_mu, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 10 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 11 => LCD_DATA <= pos_set;       --|                       --|
                     LCD_RS  <= '0';            --|                       --|
                     LCD_RW  <= '0';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 12 => LCD_EN  <= '0';            --|                       --|
                     lcd_state<= 9 ;            --|                       --|
                     auxtemp :=  0 ;            --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS =>  NULL;                                           --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|

      ------------------Peso set state--------------------------------------|
      WHEN 9 =>                                                           --|
        CASE auxtemp IS                                                   --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 00 => auxcount :=  1 ;           --|                       --|
          WHEN 01 => auxcount :=  1 ;           --|                       --|
                     LCD_DATA <= X"E1";         --|                       --|
                     LCD_RS   <= '0';           --|                       --|
                     LCD_RW   <= '0';           --|                       --|
                     LCD_EN   <= '1';           --|                       --|
          WHEN 02 => LCD_EN   <= '0';           --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero c---------|                       --|
          WHEN 03 => LCD_DATA<= std_logic_vector(to_unsigned(peso_mc, LCD_DATA'length));
                     LCD_RS  <= '1';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 04 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero d---------|                       --|
          WHEN 05 => LCD_DATA<= std_logic_vector(to_unsigned(peso_md, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 06 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime ponto--------------|                       --|
          WHEN 07 => LCD_DATA<= X"2E";          --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 08 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Imprime o numero u---------|                       --|
          WHEN 09 => LCD_DATA <= std_logic_vector(to_unsigned(peso_mu, LCD_DATA'length));
                     LCD_EN  <= '1';            --|                       --|
          WHEN 10 => LCD_EN  <= '0';            --|                       --|
          ----------------------------------------|                       --|
          --                                                              --|
          -------------Set ddram write------------|                       --|
          WHEN 11 => LCD_DATA<= pos_set;        --|                       --|
                     LCD_RS  <= '0';            --|                       --|
                     LCD_RW  <= '0';            --|                       --|
                     LCD_EN  <= '1';            --|                       --|
          WHEN 12 => LCD_EN  <= '0';            --|                       --|
                     lcd_state<= 0 ;            --|                       --|
                     auxtemp :=  0 ;            --|                       --|
          ----------------------------------------|                       --|
          WHEN OTHERS =>  NULL;                                           --|
        END CASE;                                                         --|
      ----------------------------------------------------------------------|

      WHEN OTHERS   => lcd_state <= 0;
    END CASE;
  END PROCESS lcd_process;
--------------------------------------------------------------------------------------

END object_picker;
