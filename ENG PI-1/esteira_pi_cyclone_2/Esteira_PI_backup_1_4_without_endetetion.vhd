-----------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;
-----------------------------------------
ENTITY Esteira_PI IS
  PORT ( KEY    :  IN     STD_LOGIC_VECTOR (3 DOWNTO 0);
       CLOCK_50 :  IN     STD_LOGIC;
       LCD_DATA  :  OUT    STD_LOGIC_VECTOR (7 DOWNTO 0);
       LCD_EN  :  OUT    STD_LOGIC;
       LCD_RW  :  buffer  STD_LOGIC;
       LCD_RS  :  OUT    STD_LOGIC;
       LCD_ON  :  OUT    STD_LOGIC;
       LCD_BLON  :  OUT    STD_LOGIC
     );
END Esteira_PI;
----------------------------------------
ARCHITECTURE object_picker OF Esteira_PI IS
  SIGNAL clock_100: STD_LOGIC;
      
    SIGNAL lcd_state  :INTEGER RANGE 0 TO 10 := 1;
    SIGNAL cor_e    :INTEGER RANGE 0 TO 3 := 0;
    SIGNAL cor_m    :INTEGER RANGE 0 TO 3 := 2;
    SIGNAL pos_set    :STD_LOGIC_VECTOR (7 DOWNTO 0) := X"CD";
--    SIGNAL blink    :STD_LOGIC_VECTOR := "00001101"
    
    SIGNAL altura_e  :INTEGER RANGE 0 TO 999 := 250;
    SIGNAL altura_ec  :INTEGER RANGE 0 TO 60;
    SIGNAL altura_ed  :INTEGER RANGE 0 TO 60;
    SIGNAL altura_eu  :INTEGER RANGE 0 TO 60;
    
    SIGNAL peso_e    :INTEGER RANGE 0 TO 999 := 250;
    SIGNAL peso_ec    :INTEGER RANGE 0 TO 60;
    SIGNAL peso_ed    :INTEGER RANGE 0 TO 60;
    SIGNAL peso_eu    :INTEGER RANGE 0 TO 60;
    
    SIGNAL altura_m  :INTEGER RANGE 0 TO 999 := 150;
    SIGNAL altura_mc  :INTEGER RANGE 0 TO 60;
    SIGNAL altura_md  :INTEGER RANGE 0 TO 60;
    SIGNAL altura_mu  :INTEGER RANGE 0 TO 60;
    
    SIGNAL peso_m    :INTEGER RANGE 0 TO 999 := 150;
    SIGNAL peso_mc    :INTEGER RANGE 0 TO 60;
    SIGNAL peso_md    :INTEGER RANGE 0 TO 60;
    SIGNAL peso_mu    :INTEGER RANGE 0 TO 60;
    
  BEGIN
  
  altura_ec <= ((altura_e/100) + 48);
  altura_ed <= (((altura_e/10) - ((altura_e/100)*10)) + 48);
  altura_eu <= ((altura_e rem 10) + 48);
    
  peso_ec    <= ((peso_e/100) + 48);
  peso_ed   <= (((peso_e/10) - ((peso_e/100)*10)) + 48);
  peso_eu   <= ((peso_e rem 10) + 48);  
    
  altura_mc <= ((altura_m/100) + 48);
  altura_md <= (((altura_m/10) - ((altura_m/100)*10)) + 48);
  altura_mu <= ((altura_m rem 10) + 48);
    
  peso_mc   <= ((peso_m/100) + 48);
  peso_md   <= (((peso_m/10) - ((peso_m/100)*10)) + 48);
  peso_mu   <= ((peso_m rem 10) + 48);  
    
  LCD_ON  <=    '1';
  LCD_BLON  <=    '1';
    
    
----------------------------------------------------------|
---------------------Divisor de clock---------------------|  
  PROCESS (CLOCK_50)                                    --| Divisor de clock  para  20khz
    variable count100us  :  INTEGER RANGE 0 TO 5000;    --| Periodo de 50us
    --                                                  --|
  BEGIN                                                 --|
    --                                                  --|
    IF (rising_edge(CLOCK_50)) THEN                     --|
      count100us := count100us + 1;                     --|
      IF (count100us = 2500) THEN     --2500            --|
        clock_100 <= NOT clock_100;                     --|
        count100us := 0;                                --|
      END IF;                                           --|
    END IF;                                             --|
    --                                                  --|
  END PROCESS;                                          --|
----------------------------------------------------------|
  
  
---------------------------------------------------------------------------------------
-------------------------- MAQUINA DE ESTADOS LCD --------------------------------------
  lcd_process : PROCESS
    VARIABLE auxtemp  :  INTEGER RANGE 0 TO 2000;
    VARIABLE auxcount  :  INTEGER RANGE 0 TO 1;
    VARIABLE test    :  INTEGER RANGE 0 TO 2000 :=0;
    BEGIN
      
      wait until rising_edge(clock_100);
      
      IF (auxcount=1) THEN
        auxtemp := auxtemp + 1;
      END IF;
      
      
    
    CASE lcd_state IS
      ------------------Idle state------------------------------------------|
      WHEN 0 =>                  -- Case 0 = idle                         --|
        auxtemp   :=  0 ;        -- Case 1 = Init 1                       --|
        auxcount  :=  0 ;        -- Case 2 = Init 2                       --|
        LCD_DATA  <= "00000000"; -- Case 3 = Cor set    -- Liga o blink   --|
        LCD_RS    <= '0';        -- Case 4 = Altura set -- Liga o blink   --|
        LCD_RW    <= '0';        -- Case 5 = Peso set   -- Liga o blink   --|
        LCD_EN    <= '0';        -- Case 6 = Desliga o blink              --|
        lcd_state <=  0 ;        -- Case 7 = Atualiza cor medida          --|
        --                       -- Case 8 = Atualiza peso medido         --|
        --                       -- Case 9 = Atualiza altura medida       --|
      ----------------------------------------------------------------------|

      ------------------Init 1 state----------------------------------------|
      WHEN 1 =>                                                           --|
        CASE auxtemp IS                                                   --|
                                                                          --|
          -------------Passo 1, 50ms--------------| Init                  --|
          WHEN 0    =>  auxcount :=  1 ;        --|                       --|
          WHEN 1    =>   auxcount :=  1 ;       --|                       --|
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
          -------------Passo 4--------------------| Define 8bits lcd_DATA
          WHEN 1105 =>  LCD_DATA <= "00110000"; --|
                        LCD_EN   <= '1';        --|
          WHEN 1107 =>   LCD_EN   <= '0';       --|
          ----------------------------------------|
          
          -------------Passo 5--------------------| Define 2 line and character 5x8
          WHEN 1108 =>  LCD_DATA <= "00111000"; --|
                        LCD_EN   <= '1';        --|
          WHEN 1110 =>   LCD_EN   <= '0';       --|
          ----------------------------------------|
          
          -------------Passo 6--------------------| Display off
          WHEN 1111 =>  LCD_DATA <= "00001000"; --|
                        LCD_EN  <= '1';         --|
          WHEN 1113 =>  LCD_EN  <= '0';         --|
          ----------------------------------------|

          -------------Passo 7--------------------| Clear display
          WHEN 1114 =>  LCD_DATA <= "00000001"; --|
                        LCD_EN   <= '1';        --|
          WHEN 1116 =>  LCD_EN   <= '0';        --|
          ----------------------------------------|
          
          -------------Passo 8--------------------| Entry set mode
          WHEN 1217 =>  LCD_DATA <= "00000110"; --|
                        LCD_EN   <= '1';        --|
          WHEN 1219 =>  LCD_EN   <= '0';        --|
          ----------------------------------------|
          
          -------------Passo 9--------------------| Display on
          WHEN 1220 =>  LCD_DATA <= "00001100"; --| 
                        LCD_EN   <= '1';        --|
          WHEN 1222 =>  auxtemp  :=  0 ;        --| Encerra inicialização
                        auxcount :=  0 ;        --|
                        LCD_DATA <= "00000000"; --|        
                        LCD_RS   <=  '0';       --|      
                        LCD_RW   <=  '0';       --|      
                        LCD_EN   <= '0';        --|
                        lcd_state<=  2 ;        --|  --Alterar--lcd_state<=0;--
                        auxtemp  :=  0 ;        --|
          ----------------------------------------|

          WHEN OTHERS   => NULL;
        END CASE;                
      
      
      
      WHEN 2 =>                       -------Init 2----------------
        CASE auxtemp IS                      --Clear Display
          WHEN 0 =>  auxcount:=1;
          WHEN 1 =>  auxcount:=1;
                  LCD_DATA <= "00000001";          
                  LCD_RS  <=  '0';                  
                  LCD_RW  <=  '0';                  
                  LCD_EN   <= '1';
          WHEN 2 =>  LCD_EN   <= '0';
          
          WHEN 101 =>  LCD_DATA <= X"56";                -- imprime letra V
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 102 =>  LCD_EN   <= '0';
          
          WHEN 103 =>  LCD_DATA <= X"61";                -- imprime letra a
                  LCD_EN  <= '1';
          WHEN 104 =>  LCD_EN  <= '0';                  --
          
          WHEN 105 =>  LCD_DATA <= X"6C";                -- imprime letra l
                  LCD_EN  <= '1';
          WHEN 106 =>  LCD_EN  <= '0';                  --
          
          WHEN 107 =>  LCD_DATA <= X"6F";                -- imprime letra o
                  LCD_EN  <= '1';
          WHEN 108 =>  LCD_EN  <= '0';                  --
          
          WHEN 109 =>  LCD_DATA <= X"72";                -- imprime letra r
                  LCD_EN  <= '1';
          WHEN 110 =>  LCD_EN  <= '0';                  --
          
          WHEN 111 =>  LCD_DATA <= X"65";                -- imprime letra e
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 112 =>  LCD_EN   <= '0';
          
          WHEN 113 =>  LCD_DATA <= X"73";                -- imprime letra s
                  LCD_EN  <= '1';
          WHEN 114 =>  LCD_EN  <= '0';                  --
          
          WHEN 115 =>  LCD_DATA <= X"20";                -- imprime espaço
                  LCD_EN  <= '1';
          WHEN 116 =>  LCD_EN  <= '0';                  --
          
          WHEN 117 =>  LCD_DATA <= X"53";                -- imprime letra S
                  LCD_EN  <= '1';
          WHEN 118 =>  LCD_EN  <= '0';                  --
          
          WHEN 119 =>  LCD_DATA <= X"65";                -- imprime letra e
                  LCD_EN  <= '1';
          WHEN 120 =>  LCD_EN  <= '0';                  --
      
          WHEN 121 =>  LCD_DATA <= X"74";                -- imprime letra t
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 122 =>  LCD_EN   <= '0';
          
          WHEN 123 =>  LCD_DATA <= X"2E";                -- imprime ponto
                  LCD_EN  <= '1';
          WHEN 124 =>  LCD_EN  <= '0';                  --
          
          WHEN 125 =>  LCD_DATA <= X"20";                -- imprime espaço
                  LCD_EN  <= '1';
          WHEN 126 =>  LCD_EN  <= '0';                  --
          
          WHEN 127 =>  LCD_DATA <= X"4D";                -- imprime letra M
                  LCD_EN  <= '1';
          WHEN 128 =>  LCD_EN  <= '0';                  --
          
          WHEN 129 =>  LCD_DATA <= X"65";                -- imprime letra e
                  LCD_EN  <= '1';
          WHEN 130 =>  LCD_EN  <= '0';                  --
      
          WHEN 131 =>  LCD_DATA <= X"64";                -- imprime letra d
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 132 =>  LCD_EN   <= '0';
          
          WHEN 133 =>  LCD_DATA <= X"2E";                -- imprime ponto
                  LCD_EN  <= '1';
          WHEN 134 =>  LCD_EN  <= '0';                  --
          
          WHEN 135 =>  LCD_DATA <= X"20";                -- imprime espaço
                  LCD_EN  <= '1';
          WHEN 136 =>  LCD_EN  <= '0';                  --
          
          WHEN 137 =>  LCD_DATA <= X"55";                -- imprime letra U
                  LCD_EN  <= '1';
          WHEN 138 =>  LCD_EN  <= '0';                  --
          
          WHEN 139 =>  LCD_DATA <= X"6E";                -- imprime letra n
                  LCD_EN  <= '1';
          WHEN 140 =>  LCD_EN  <= '0';                  --
          
          WHEN 141 =>  LCD_DATA <= X"C0";                --  Set line write 
                  auxcount:=1;                    -- X"80" 1line
                  LCD_RS  <=  '0';                  --  X"C0" 2line
                  LCD_RW  <=  '0';                  --  X"94" 3line
                  LCD_EN   <= '1';                  --  X"D4" 4line
          WHEN 142 =>  LCD_EN   <= '0';
          
          WHEN 143 =>  LCD_DATA <= X"43";                -- test, imprime letra C
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 144 =>  LCD_EN   <= '0';
          
          WHEN 145 =>  LCD_DATA <= X"6F";                -- test, imprime letra o
                  LCD_EN  <= '1';
          WHEN 146 =>  LCD_EN  <= '0';                  --
          
          WHEN 147 =>  LCD_DATA <= X"72";                -- test, imprime letra r
                  LCD_EN  <= '1';
          WHEN 148 =>  LCD_EN  <= '0';                  --
          
          WHEN 149 =>  LCD_DATA <= X"3A";                -- test, imprime letra :
                  LCD_EN  <= '1';
          WHEN 150 =>  LCD_EN  <= '0';                  --

          WHEN 151 =>  LCD_DATA <= X"94";                --  Set line write 
                  auxcount:=1;                    -- X"80" 1line
                  LCD_RS  <=  '0';                  --  X"C0" 2line
                  LCD_RW  <=  '0';                  --  X"94" 3line
                  LCD_EN   <= '1';                  --  X"D4" 4line
          WHEN 152 =>  LCD_EN   <= '0';
          
          WHEN 153 =>  LCD_DATA <= X"41";                -- imprime letra A
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 154 =>  LCD_EN   <= '0';
          
          WHEN 155 =>  LCD_DATA <= X"6C";                -- imprime letra l
                  LCD_EN  <= '1';
          WHEN 156 =>  LCD_EN  <= '0';                  --
          
          WHEN 157 =>  LCD_DATA <= X"74";                -- imprime letra t
                  LCD_EN  <= '1';
          WHEN 158 =>  LCD_EN  <= '0';                  --
          
          WHEN 159 =>  LCD_DATA <= X"75";                -- imprime letra u
                  LCD_EN  <= '1';
          WHEN 160 =>  LCD_EN  <= '0';                  --
          
          WHEN 161 =>  LCD_DATA <= X"72";                -- imprime letra r
                  LCD_EN  <= '1';
          WHEN 162 =>  LCD_EN  <= '0';                  --
          
          WHEN 163 =>  LCD_DATA <= X"61";                -- imprime letra a
                  LCD_EN  <= '1';
          WHEN 164 =>  LCD_EN  <= '0';                  --
          
          WHEN 165 =>  LCD_DATA <= X"3A";                -- imprime letra :
                  LCD_EN  <= '1';
          WHEN 166 =>  LCD_EN  <= '0';                  --        
          
          WHEN 167 =>  LCD_DATA <= X"D4";                --  Set line write 
                  auxcount:=1;                    -- X"80" 1line
                  LCD_RS  <=  '0';                  --  X"C0" 2line
                  LCD_RW  <=  '0';                  --  X"94" 3line
                  LCD_EN   <= '1';                  --  X"D4" 4line
          WHEN 168 =>  LCD_EN   <= '0';      
          
          WHEN 169 =>  LCD_DATA <= X"50";                -- imprime letra P
                  LCD_RS  <=  '1';
                  LCD_EN   <= '1';
          WHEN 170 =>  LCD_EN   <= '0';
          
          WHEN 171 =>  LCD_DATA <= X"65";                -- imprime letra e
                  LCD_EN  <= '1';
          WHEN 172 =>  LCD_EN  <= '0';                  --
          
          WHEN 173 =>  LCD_DATA <= X"73";                -- imprime letra s
                  LCD_EN  <= '1';
          WHEN 174 =>  LCD_EN  <= '0';                  --
          
          WHEN 175 =>  LCD_DATA <= X"6F";                -- imprime letra o
                  LCD_EN  <= '1';
          WHEN 176 =>  LCD_EN  <= '0';                  --
          
          WHEN 177 =>  LCD_DATA <= X"3A";                -- imprime letra :
                  LCD_EN  <= '1';
          WHEN 178 =>  LCD_EN  <= '0';                  --
          
          WHEN 179 =>  LCD_DATA <= X"A6";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
          WHEN 180 =>  LCD_EN   <= '0';
          
          WHEN 181 =>  LCD_DATA <= X"63";                -- imprime letra c
                  LCD_RS  <=  '1';
                  LCD_EN  <= '1';
          WHEN 182 =>  LCD_EN  <= '0';                  --
          
          WHEN 183 =>  LCD_DATA <= X"6D";                -- imprime letra m
                  LCD_EN  <= '1';
          WHEN 184 =>  LCD_EN  <= '0';                  --
          
          WHEN 185 =>  LCD_DATA <= X"E7";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
          WHEN 186 =>  LCD_EN   <= '0';
          
          WHEN 187 =>  LCD_DATA <= X"67";                -- imprime letra g
                  LCD_RS  <=  '1';
                  LCD_EN  <= '1';
          WHEN 188 =>  LCD_EN  <= '0';                  --
                  LCD_state<=  3 ;
                  auxtemp := 0;
          WHEN OTHERS => NULL;
        END CASE;
        
      WHEN 3 => 
        CASE auxtemp IS
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= X"C8";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
                  pos_set  <= X"C8";
          WHEN 02 =>  LCD_EN   <= '0';
          
          WHEN 03 =>  LCD_DATA <= "00001101";  ------------------ Blink on
                  LCD_RS  <=  '0';
                  LCD_RW  <=  '0';                  
                  LCD_EN  <= '1';  
          WHEN 04 =>  LCD_EN   <= '0';
          
          WHEN OTHERS => 
            CASE cor_e IS
              WHEN 0 => 
                CASE auxtemp IS
                  WHEN 05 =>  LCD_DATA <= X"44";                -- test, imprime letra D
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 06 =>  LCD_EN   <= '0';
                  
                  WHEN 07 =>  LCD_DATA <= X"73";                -- test, imprime letra s
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 09 =>  LCD_DATA <= X"74";                -- test, imprime letra t
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                
                  WHEN 11 =>  LCD_DATA <= X"76";                -- test, imprime letra v
                          LCD_EN  <= '1';
                  WHEN 12 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 13 =>  LCD_DATA <= X"C8";                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 14 =>  LCD_EN   <= '0';
                          lcd_state<=  4 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              
              WHEN 1 => 
                CASE auxtemp IS
                  WHEN 05 =>  LCD_DATA <= X"56";                -- test, imprime letra V
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 06 =>  LCD_EN   <= '0';
                  
                  WHEN 07 =>  LCD_DATA <= X"65";                -- test, imprime letra e
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 09 =>  LCD_DATA <= X"72";                -- test, imprime letra r
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                
                  WHEN 11 =>  LCD_DATA <= X"6D";                -- test, imprime letra m
                          LCD_EN  <= '1';
                  WHEN 12 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 13 =>  LCD_DATA <= X"C8";                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 14 =>  LCD_EN   <= '0';
                          lcd_state<=  0 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              
              WHEN 2 => 
                CASE auxtemp IS
                  WHEN 05 =>  LCD_DATA <= X"56";                -- test, imprime letra V
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 06 =>  LCD_EN   <= '0';
                  
                  WHEN 07 =>  LCD_DATA <= X"65";                -- test, imprime letra e
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 09 =>  LCD_DATA <= X"72";                -- test, imprime letra r
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                
                  WHEN 11 =>  LCD_DATA <= X"64";                -- test, imprime letra d
                          LCD_EN  <= '1';
                  WHEN 12 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 13 =>  LCD_DATA <= X"C8";                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 14 =>  LCD_EN   <= '0';
                          lcd_state<=  0 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              
              WHEN 3 => 
                CASE auxtemp IS
                  WHEN 05 =>  LCD_DATA <= X"41";                -- test, imprime letra A
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 06 =>  LCD_EN   <= '0';
                  
                  WHEN 07 =>  LCD_DATA <= X"7A";                -- test, imprime letra z
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 09 =>  LCD_DATA <= X"75";                -- test, imprime letra u
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                
                  WHEN 11 =>  LCD_DATA <= X"6C";                -- test, imprime letra l
                          LCD_EN  <= '1';
                  WHEN 12 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 13 =>  LCD_DATA <= X"C8";                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 14 =>  LCD_EN   <= '0';
                          lcd_state<=  0 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              WHEN OTHERS => lcd_state <= 0;
            END CASE;
        END CASE;
        
      WHEN 4 =>
      
        CASE auxtemp IS                            
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= X"9C";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
                  pos_set  <= X"9C";
          WHEN 02 =>  LCD_EN   <= '0';
          
          WHEN 03 =>  LCD_DATA <= "00001101";  ------------------ Blink on
                  LCD_RS  <=  '0';
                  LCD_RW  <=  '0';                  
                  LCD_EN  <= '1';  
          WHEN 04 =>  LCD_EN   <= '0';
          
          WHEN 05 =>  LCD_DATA <= std_logic_vector(to_unsigned(altura_ec, LCD_DATA'length));                -- imprime letra r
                  LCD_RS  <=  '1';
                  LCD_EN  <= '1';
          WHEN 06 =>  LCD_EN  <= '0';                  --
          
          WHEN 07 =>  LCD_DATA <= std_logic_vector(to_unsigned(altura_ed, LCD_DATA'length));                -- imprime letra a
                  LCD_EN  <= '1';
          WHEN 08 =>  LCD_EN  <= '0';                  --
          
          WHEN 09 =>  LCD_DATA <= X"2E";                -- imprime ponto
                  LCD_EN  <= '1';
          WHEN 10 =>  LCD_EN  <= '0';
          
          WHEN 11 =>  LCD_DATA <= std_logic_vector(to_unsigned(altura_eu, LCD_DATA'length));                -- imprime letra :
                  LCD_EN  <= '1';
          WHEN 12 =>  LCD_EN  <= '0';                  --
          
          WHEN 13 =>  LCD_DATA <= X"9C";                --Set ddram        
                  LCD_RS  <=  '0';            
                  LCD_RW  <=  '0';            
                  LCD_EN   <= '1';
          WHEN 14 =>  LCD_EN   <= '0';
                  lcd_state<=  5 ;
                  auxtemp := 0;
          WHEN OTHERS =>  NULL;    
        END CASE;
      
      WHEN 5 =>
        CASE auxtemp IS                            --Clear Display
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= X"DC";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
                  pos_set  <= X"DC";
          WHEN 02 =>  LCD_EN   <= '0';
          
          WHEN 03 =>  LCD_DATA <= "00001101";  ------------------ Blink on
                  LCD_RS  <=  '0';
                  LCD_RW  <=  '0';                  
                  LCD_EN  <= '1';  
          WHEN 04 =>  LCD_EN   <= '0';
          
          WHEN 05 =>  LCD_DATA <= std_logic_vector(to_unsigned(peso_ec, LCD_DATA'length));                -- imprime letra r
                  LCD_RS  <=  '1';
                  LCD_EN  <= '1';
          WHEN 06 =>  LCD_EN  <= '0';                  --
          
          WHEN 07 =>  LCD_DATA <= std_logic_vector(to_unsigned(peso_ed, LCD_DATA'length));                -- imprime letra a
                  LCD_EN  <= '1';
          WHEN 08 =>  LCD_EN  <= '0';                  --
          
          WHEN 09 =>  LCD_DATA <= X"2E";                -- imprime ponto
                  LCD_EN  <= '1';
          WHEN 10 =>  LCD_EN  <= '0';
          
          WHEN 11 =>  LCD_DATA <= std_logic_vector(to_unsigned(peso_eu, LCD_DATA'length));                -- imprime letra :
                  LCD_EN  <= '1';
          WHEN 12 =>  LCD_EN  <= '0';                  --
          
          WHEN 13 =>  LCD_DATA <= X"DC";                --Set ddram        
                  LCD_RS  <=  '0';            
                  LCD_RW  <=  '0';            
                  LCD_EN   <= '1';
          WHEN 14 =>  LCD_EN   <= '0';
                  lcd_state<=  6 ;
                  auxtemp := 0;
          WHEN OTHERS =>  NULL;    
        END CASE;
        
        WHEN 6 =>  ------------------------ Blink off
        CASE auxtemp IS
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= "00001100";  
                  LCD_RS  <=  '0';
                  LCD_RW  <=  '0';                  
                  LCD_EN  <= '1';  
          WHEN 02 =>  LCD_EN   <= '0';
                  lcd_state<=  7 ;
                  auxtemp  :=   0 ;
          WHEN OTHERS =>  NULL;  
        END CASE;  
        
        WHEN 7 => 
        CASE auxtemp IS
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= X"CD";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
          WHEN 02 =>  LCD_EN   <= '0';
          
          WHEN OTHERS => 
            CASE cor_m IS
              WHEN 0 => 
                CASE auxtemp IS
                  WHEN 03 =>  LCD_DATA <= X"44";                -- test, imprime letra D
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 04 =>  LCD_EN   <= '0';
                  
                  WHEN 05 =>  LCD_DATA <= X"73";                -- test, imprime letra s
                          LCD_EN  <= '1';
                  WHEN 06 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 07 =>  LCD_DATA <= X"74";                -- test, imprime letra t
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                
                  WHEN 09 =>  LCD_DATA <= X"76";                -- test, imprime letra v
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 11 =>  LCD_DATA <= pos_set;                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 12 =>  LCD_EN   <= '0';
                          lcd_state<=  0 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              
              WHEN 1 => 
                CASE auxtemp IS
                  WHEN 03 =>  LCD_DATA <= X"56";                -- test, imprime letra V
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 04 =>  LCD_EN   <= '0';
                  
                  WHEN 05 =>  LCD_DATA <= X"65";                -- test, imprime letra e
                          LCD_EN  <= '1';
                  WHEN 06 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 07 =>  LCD_DATA <= X"72";                -- test, imprime letra r
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                
                  WHEN 09 =>  LCD_DATA <= X"6D";                -- test, imprime letra m
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 11 =>  LCD_DATA <= pos_set;                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 12 =>  LCD_EN   <= '0';
                          lcd_state<=  0 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              
              WHEN 2 => 
                CASE auxtemp IS
                  WHEN 03 =>  LCD_DATA <= X"56";                -- test, imprime letra V
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 04 =>  LCD_EN   <= '0';
                  
                  WHEN 05 =>  LCD_DATA <= X"65";                -- test, imprime letra e
                          LCD_EN  <= '1';
                  WHEN 06 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 07 =>  LCD_DATA <= X"72";                -- test, imprime letra r
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                
                  WHEN 09 =>  LCD_DATA <= X"64";                -- test, imprime letra d
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 11 =>  LCD_DATA <= pos_set;                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 12 =>  LCD_EN   <= '0';
                          lcd_state<=  8 ;
                          auxtemp:=0;
                  WHEN OTHERS => NULL;
                END CASE;
              
              WHEN 3 => 
                CASE auxtemp IS
                  WHEN 03 =>  LCD_DATA <= X"41";                -- test, imprime letra A
                          LCD_RS  <=  '1';
                          LCD_EN   <= '1';
                  WHEN 04 =>  LCD_EN   <= '0';
                  
                  WHEN 05 =>  LCD_DATA <= X"7A";                -- test, imprime letra z
                          LCD_EN  <= '1';
                  WHEN 06 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 07 =>  LCD_DATA <= X"75";                -- test, imprime letra u
                          LCD_EN  <= '1';
                  WHEN 08 =>  LCD_EN  <= '0';                  --
                
                  WHEN 09 =>  LCD_DATA <= X"6C";                -- test, imprime letra l
                          LCD_EN  <= '1';
                  WHEN 10 =>  LCD_EN  <= '0';                  --
                  
                  WHEN 11 =>  LCD_DATA <= pos_set;                --Set ddram        
                          LCD_RS  <=  '0';            
                          LCD_RW  <=  '0';            
                          LCD_EN   <= '1';
                  WHEN 12 =>  LCD_EN   <= '0';
                          lcd_state<=  0 ;
                          auxtemp := 0;
                  WHEN OTHERS => NULL;
                END CASE;
              WHEN OTHERS => NULL;
            END CASE;
        END CASE;
        
      WHEN 8 =>
        CASE auxtemp IS                            
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= X"A1";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
          WHEN 02 =>  LCD_EN   <= '0';
          
          WHEN 03 =>  LCD_DATA <= std_logic_vector(to_unsigned(altura_mc, LCD_DATA'length));                -- imprime letra r
                  LCD_RS  <=  '1';
                  LCD_EN  <= '1';
          WHEN 04 =>  LCD_EN  <= '0';                  --
          
          WHEN 05 =>  LCD_DATA <= std_logic_vector(to_unsigned(altura_md, LCD_DATA'length));                -- imprime letra a
                  LCD_EN  <= '1';
          WHEN 06 =>  LCD_EN  <= '0';                  --
          
          WHEN 07 =>  LCD_DATA <= X"2E";                -- imprime ponto
                  LCD_EN  <= '1';
          WHEN 08 =>  LCD_EN  <= '0';
          
          WHEN 09 =>  LCD_DATA <= std_logic_vector(to_unsigned(altura_mu, LCD_DATA'length));                -- imprime letra :
                  LCD_EN  <= '1';
          WHEN 10 =>  LCD_EN  <= '0';                  --
          
          WHEN 11 =>  LCD_DATA <= pos_set;                --Set ddram        
                  LCD_RS  <=  '0';            
                  LCD_RW  <=  '0';            
                  LCD_EN   <= '1';
          WHEN 12 =>  LCD_EN   <= '0';
                  lcd_state<=  9 ;
                  auxtemp := 0;
          WHEN OTHERS =>  NULL;    
        END CASE;
      
      WHEN 9 =>
        CASE auxtemp IS                            
          WHEN 00 =>  auxcount :=  1 ;
          WHEN 01 =>  auxcount :=  1 ;
                  LCD_DATA <= X"E1";          --  X"80" 1line set ddram --  X"C0" 2line
                  LCD_RS  <=  '0';            --  X"94" 3line
                  LCD_RW  <=  '0';            --  X"D4" 4line
                  LCD_EN   <= '1';
          WHEN 02 =>  LCD_EN   <= '0';
          
          WHEN 03 =>  LCD_DATA <= std_logic_vector(to_unsigned(peso_mc, LCD_DATA'length));                -- imprime letra r
                  LCD_RS  <=  '1';
                  LCD_EN  <= '1';
          WHEN 04 =>  LCD_EN  <= '0';                  --
          
          WHEN 05 =>  LCD_DATA <= std_logic_vector(to_unsigned(peso_md, LCD_DATA'length));                -- imprime letra a
                  LCD_EN  <= '1';
          WHEN 06 =>  LCD_EN  <= '0';                  --
          
          WHEN 07 =>  LCD_DATA <= X"2E";                -- imprime ponto
                  LCD_EN  <= '1';
          WHEN 08 =>  LCD_EN  <= '0';
          
          WHEN 09 =>  LCD_DATA <= std_logic_vector(to_unsigned(peso_mu, LCD_DATA'length));                -- imprime letra :
                  LCD_EN  <= '1';
          WHEN 10 =>  LCD_EN  <= '0';                  --
          
          WHEN 11 =>  LCD_DATA <= pos_set;                --Set ddram        
                  LCD_RS  <=  '0';            
                  LCD_RW  <=  '0';            
                  LCD_EN   <= '1';
          WHEN 12 =>  LCD_EN   <= '0';
                  lcd_state<=  0 ;
                  auxtemp := 0;
          WHEN OTHERS =>  NULL;    
        END CASE;
        
      WHEN OTHERS   => lcd_state <= 0;
    END CASE;
  END PROCESS lcd_process;
--------------------------------------------------------------------------------------

END object_picker;
