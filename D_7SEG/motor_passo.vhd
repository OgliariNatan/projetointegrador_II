library IEEE;   
use IEEE.STD_LOGIC_1164.ALL;

entity MotorPasso is      
port(

  clk: in std_logic; ---clock do sistema
  reset: in std_logic; ---volta a posição inicial
  sentido: in std_logic; ---muda o sentido de giro
  y: out std_logic_vector (3 downto 0)
  ); ---saida
 
end MotorPasso;

architecture imp of MotorPasso is
type estado is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24);
signal anterior,proximo:estado;

begin

  sequencial:process(clk)
  begin
    if(clk'event and clk='1') then
     
        anterior<=proximo;
     
    end if;
  end process sequencial;
 
  combinacional:process(anterior,sentido,reset)
  begin
    case anterior is
     ----------------------------------- POSIÇÃO INICIAL
         when S0=>
             Y<="0110";
                if(reset='1') then
                proximo <= S0;
            elsif(sentido='0') then
             proximo <= S1;
            else
             proximo <= S13;
            end if;
    ------------------------------------ LADO DIREITO
         when S1=>
             Y<="0111";
                if(reset='1') then
                proximo <= S0;
            elsif(sentido='0') then
             proximo <= S2;
            else
             proximo <= S0;
            end if;
                
         when S2=>
             Y<="0011";
                if(reset='1') then
                proximo <= S1;
            elsif(sentido='0') then
             proximo <= S3;
            else
            proximo <= S1;
            end if;
                
            when S3=>
             Y<="1011";
                if(reset='1') then
                proximo <= S2;
            elsif(sentido='0') then
             proximo <= S4;
            else
            proximo <= S2;
            end if;
                
            when S4=>
             Y<="1001";
                if(reset='1') then
                proximo <= S3;
            elsif(sentido='0') then
             proximo <= S5;
            else
            proximo <= S3;
            end if;
                
            when S5=>
             Y<="1101";
                if(reset='1') then
                proximo <= S4;
            elsif(sentido='0') then
             proximo <= S6;
            else
            proximo <= S4;
            end if;
                
            when S6=>
             Y<="1100";
                if(reset='1') then
                proximo <= S5;
            elsif(sentido='0') then
             proximo <= S7;
            else
            proximo <= S5;
            end if;
            
            when S7=>
             Y<="1110";
                if(reset='1') then
                proximo <= S6;
            elsif(sentido='0') then
             proximo <= S8;
            else
            proximo <= S6;
            end if;
                
            when S8=>
             Y<="0110";
                if(reset='1') then
                proximo <= S7;
            elsif(sentido='0') then
             proximo <= S9;
            else
            proximo <= S7;
            end if;
            
            when S9=>
             Y<="0111";
                if(reset='1') then
                proximo <= S8;
            elsif(sentido='0') then
             proximo <= S10;
            else
            proximo <= S8;
            end if;
                
            when S10=>
             Y<="0011";
                if(reset='1') then
                proximo <= S9;
            elsif(sentido='0') then
             proximo <= S11;
            else
            proximo <= S9;
            end if;
            
            when S11=>
             Y<="1011";
                if(reset='1') then
                proximo <= S10;
            elsif(sentido='0') then
             proximo <= S12;
            else
            proximo <= S10;
            end if;
            
            when S12=>
             Y<="1001";
                if(reset='1') then
                proximo <= S11;
            elsif(sentido='0') then
             proximo <= S12;
            else
            proximo <= S11;
            end if;
                
                ----------------------- outro ladO
            when S13=>
             Y<="1110";
                if(reset='1') then
                proximo <= S0;
            elsif(sentido='1') then
             proximo <= S14;
            else
            proximo <= S0;
            end if;
                
            when S14=>
             Y<="1100";
                if(reset='1') then
                proximo <= S13;
            elsif(sentido='1') then
             proximo <= S15;
            else
            proximo <= S13;
            end if;
                
            when S15=>
             Y<="1101";
                if(reset='1') then
                proximo <= S14;
            elsif(sentido='1') then
             proximo <= S16;
            else
            proximo <= S14;
            end if;
                
            when S16=>
             Y<="1001";
                if(reset='1') then
                proximo <= S15;
            elsif(sentido='1') then
             proximo <= S17;
            else
            proximo <= S15;
            end if;
                
            when S17=>
             Y<="1011";
                if(reset='1') then
                proximo <= S16;
            elsif(sentido='1') then
             proximo <= S18;
            else
            proximo <= S16;
            end if;
                
            when S18=>
             Y<="0011";
                if(reset='1') then
                proximo <= S17;
            elsif(sentido='1') then
             proximo <= S19;
            else
            proximo <= S17;
            end if;
                
            when S19=>
             Y<="0111";
                if(reset='1') then
                proximo <= S18;
            elsif(sentido='1') then
             proximo <= S20;
            else
            proximo <= S18;
            end if;
                
            when S20=>
             Y<="0110";
                if(reset='1') then
                proximo <= S19;
            elsif(sentido='1') then
             proximo <= S21;
            else
            proximo <= S19;
            end if;
                
            when S21=>
             Y<="1110";
                if(reset='1') then
                proximo <= S20;
            elsif(sentido='1') then
             proximo <= S22;
            else
            proximo <= S20;
            end if;
                
            when S22=>
             Y<="1100";
                if(reset='1') then
                proximo <= S21;
            elsif(sentido='1') then
             proximo <= S23;
            else
            proximo <= S21;
            end if;
                
            when S23=>
             Y<="1101";
                if(reset='1') then
                proximo <= S22;
            elsif(sentido='1') then
             proximo <= S24;
            else
            proximo <= S22;
            end if;
                
            when S24=>
             Y<="1001";
                if(reset='1') then
                proximo <= S23;
            elsif(sentido='1') then
             proximo <= S24;
            else
            proximo <= S23;
            end if;
                
         when others=> Y <="1111";

    end case;
  end process combinacional;

end imp;


