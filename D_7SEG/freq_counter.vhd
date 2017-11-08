-- *
-- * freq_counter.vhd
-- *
-- *  Created on: Mar 21, 2017
-- *      Author: Renan Augusto Starke
-- *
-- *      IFSC -- DALEN--           
--------------------------------------------/

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity freq_counter is
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		pulse	: in std_logic;
		err		: out std_logic;
		
		data_out : out std_logic_vector(15 downto 0)
	);
end entity freq_counter;

architecture RTL of freq_counter is
	signal count, prev_count : std_logic_vector(15 downto 0);
begin

	-- simple counter process
	-- max frequency is clk
	process(clk, rst)
	begin
		if (rst = '1') then
			count <= (others => '0');
		else
			if rising_edge(clk) then
				count <= count + 1;
			end if;
		end if;	
	end process;
	
	
	process(pulse, rst)
	begin
		if (rst = '1') then
			prev_count <= (others => '0');
			data_out <= (others => '0');
		else
			if rising_edge(pulse) then
				
				if (prev_count < count) then
					data_out <= count - prev_count;
					err <= '0';
				elsif (prev_count > count) then
					 data_out <= prev_count + count;     
            	 err <= '0';
            	else
            		data_out <= (others => '0');
            		err <= '1';
            	end if;
            	
            	prev_count <= count;			
				
			end if;
		end if;	
	end process;

end architecture RTL;
