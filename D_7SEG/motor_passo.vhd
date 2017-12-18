library IEEE;   
use IEEE.STD_LOGIC_1164.ALL;

entity StepMotor is      
port(

  MOT_CLK: in std_logic; 										--		Clock dos pulsos do motor
  MOT_RST: in std_logic; 										--		Retorna a posição central
  MOT_SIDE: in std_logic; 										--		esquerda/ direita
  MOT_OUT: out std_logic_vector (3 downto 0)); 			--		bobinas do motor
 
end StepMotor;

architecture workFlow of StepMotor is
type state is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24);
signal prev_state,next_state:state;

begin

 
  fsm_state:process(MOT_CLK)
  begin
    if(MOT_CLK'event and MOT_CLK='1') then
     
        prev_state<=next_state;
     
    end if;
  end process fsm_state;
 
  fsm_moore:process(prev_state,MOT_SIDE,MOT_RST)
  begin
    case prev_state is
     ----------------------------------- POSIÇÃO INICIAL
         when S0=>
             MOT_OUT<="0110";
                if(MOT_RST='1') then
                next_state <= S0;
            elsif(MOT_SIDE='0') then
             next_state <= S1;
            else
             next_state <= S13;
            end if;
    ------------------------------------ LADO DIREITO
         when S1=>
             MOT_OUT<="0111";
                if(MOT_RST='1') then
                next_state <= S0;
            elsif(MOT_SIDE='0') then
             next_state <= S2;
            else
             next_state <= S0;
            end if;
                
         when S2=>
             MOT_OUT<="0011";
                if(MOT_RST='1') then
                next_state <= S1;
            elsif(MOT_SIDE='0') then
             next_state <= S3;
            else
            next_state <= S1;
            end if;
                
            when S3=>
             MOT_OUT<="1011";
                if(MOT_RST='1') then
                next_state <= S2;
            elsif(MOT_SIDE='0') then
             next_state <= S4;
            else
            next_state <= S2;
            end if;
                
            when S4=>
             MOT_OUT<="1001";
                if(MOT_RST='1') then
                next_state <= S3;
            elsif(MOT_SIDE='0') then
             next_state <= S5;
            else
            next_state <= S3;
            end if;
                
            when S5=>
             MOT_OUT<="1101";
                if(MOT_RST='1') then
                next_state <= S4;
            elsif(MOT_SIDE='0') then
             next_state <= S6;
            else
            next_state <= S4;
            end if;
                
            when S6=>
             MOT_OUT<="1100";
                if(MOT_RST='1') then
                next_state <= S5;
            elsif(MOT_SIDE='0') then
             next_state <= S7;
            else
            next_state <= S5;
            end if;
            
            when S7=>
             MOT_OUT<="1110";
                if(MOT_RST='1') then
                next_state <= S6;
            elsif(MOT_SIDE='0') then
             next_state <= S8;
            else
            next_state <= S6;
            end if;
                
            when S8=>
             MOT_OUT<="0110";
                if(MOT_RST='1') then
                next_state <= S7;
            elsif(MOT_SIDE='0') then
             next_state <= S9;
            else
            next_state <= S7;
            end if;
            
            when S9=>
             MOT_OUT<="0111";
                if(MOT_RST='1') then
                next_state <= S8;
            elsif(MOT_SIDE='0') then
             next_state <= S10;
            else
            next_state <= S8;
            end if;
                
            when S10=>
             MOT_OUT<="0011";
                if(MOT_RST='1') then
                next_state <= S9;
            elsif(MOT_SIDE='0') then
             next_state <= S11;
            else
            next_state <= S9;
            end if;
            
            when S11=>
             MOT_OUT<="1011";
                if(MOT_RST='1') then
                next_state <= S10;
            elsif(MOT_SIDE='0') then
             next_state <= S12;
            else
            next_state <= S10;
            end if;
            
            when S12=>
             MOT_OUT<="1001";
                if(MOT_RST='1') then
                next_state <= S11;
            elsif(MOT_SIDE='0') then
             next_state <= S12;
            else
            next_state <= S11;
            end if;
                
                ----------------------- outro ladO
            when S13=>
             MOT_OUT<="1110";
                if(MOT_RST='1') then
                next_state <= S0;
            elsif(MOT_SIDE='1') then
             next_state <= S14;
            else
            next_state <= S0;
            end if;
                
            when S14=>
             MOT_OUT<="1100";
                if(MOT_RST='1') then
                next_state <= S13;
            elsif(MOT_SIDE='1') then
             next_state <= S15;
            else
            next_state <= S13;
            end if;
                
            when S15=>
             MOT_OUT<="1101";
                if(MOT_RST='1') then
                next_state <= S14;
            elsif(MOT_SIDE='1') then
             next_state <= S16;
            else
            next_state <= S14;
            end if;
                
            when S16=>
             MOT_OUT<="1001";
                if(MOT_RST='1') then
                next_state <= S15;
            elsif(MOT_SIDE='1') then
             next_state <= S17;
            else
            next_state <= S15;
            end if;
                
            when S17=>
             MOT_OUT<="1011";
                if(MOT_RST='1') then
                next_state <= S16;
            elsif(MOT_SIDE='1') then
             next_state <= S18;
            else
            next_state <= S16;
            end if;
                
            when S18=>
             MOT_OUT<="0011";
                if(MOT_RST='1') then
                next_state <= S17;
            elsif(MOT_SIDE='1') then
             next_state <= S19;
            else
            next_state <= S17;
            end if;
                
            when S19=>
             MOT_OUT<="0111";
                if(MOT_RST='1') then
                next_state <= S18;
            elsif(MOT_SIDE='1') then
             next_state <= S20;
            else
            next_state <= S18;
            end if;
                
            when S20=>
             MOT_OUT<="0110";
                if(MOT_RST='1') then
                next_state <= S19;
            elsif(MOT_SIDE='1') then
             next_state <= S21;
            else
            next_state <= S19;
            end if;
                
            when S21=>
             MOT_OUT<="1110";
                if(MOT_RST='1') then
                next_state <= S20;
            elsif(MOT_SIDE='1') then
             next_state <= S22;
            else
            next_state <= S20;
            end if;
                
            when S22=>
             MOT_OUT<="1100";
                if(MOT_RST='1') then
                next_state <= S21;
            elsif(MOT_SIDE='1') then
             next_state <= S23;
            else
            next_state <= S21;
            end if;
                
            when S23=>
             MOT_OUT<="1101";
                if(MOT_RST='1') then
                next_state <= S22;
            elsif(MOT_SIDE='1') then
             next_state <= S24;
            else
            next_state <= S22;
            end if;
                
            when S24=>
             MOT_OUT<="1001";
                if(MOT_RST='1') then
                next_state <= S23;
            elsif(MOT_SIDE='1') then
             next_state <= S24;
            else
            next_state <= S23;
            end if;
                
         when others=> MOT_OUT <="1111";

    end case;
  end process fsm_moore;

end workFlow;


