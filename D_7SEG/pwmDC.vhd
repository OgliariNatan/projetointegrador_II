--pwmDC

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity pwmDC is
    Port ( CLK      : in  STD_LOGIC;
			  ENABLE   : in STD_LOGIC;
           DUTY     : in  STD_LOGIC_VECTOR (3 downto 0);
           pino     : out STD_LOGIC_VECTOR
			 );
end pwmDC;

architecture Behavioral of pwmDC is

	signal COUNTER : std_logic_vector (3 downto 0) := "0000";

begin

	process (CLK, ENABLE)
	begin
		if rising_edge(CLK) then
			if COUNTER="1111" then
				COUNTER <= "0000";
			else
				COUNTER <= COUNTER + '1';
			end if;

			if COUNTER>DUTY then
        pino <= "10000000";
        --PWM_OUT <= '0';
			elsif DUTY/="0000" then
        pino <= "01000000";
        --PWM_OUT <= '1';
			end if;
		end if;
	end process;

end Behavioral;
