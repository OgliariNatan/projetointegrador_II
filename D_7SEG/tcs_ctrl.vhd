-- *
-- * tcs_ctrl.vhd
-- *
-- *  Created on: Mar 21, 2017
-- *      Author: Renan Augusto Starke
-- *
-- *      IFSC -- DALEN--           
--------------------------------------------/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
	generic (
		SAMPLES_PER_FILTER : integer := 64	
	);
	
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		en : in std_logic;
		
		-- filter sel 
		-- "00" red filter
		-- "10" blue fitler
		-- "01" no filter
		-- "11" green filter
		filter_sel : out std_logic_vector(1 downto 0);
		filter_done : out std_logic;
		reload_reg : out std_logic;
		done : out std_logic
	);
end entity fsm;

architecture RTL of fsm is
	
	constant RED_FILTER_SEL : std_logic_vector(1 downto 0) := "00";
	constant BLUE_FILTER_SEL : std_logic_vector(1 downto 0) := "10";
	constant GREEN_FILTER_SEL : std_logic_vector(1 downto 0) := "11";
	constant NO_FILTER_SEL : std_logic_vector(1 downto 0) := "01";	
	
	type state_type is (IDLE, RED_FILTER, BLUE_FILTER, GREEN_FILTER, READY);
	
	signal current_state, next_state : state_type;
	
	signal samples : natural range 0 to  SAMPLES_PER_FILTER;
	signal local_rst : std_logic;
begin

	-- state transition 
	state_transition: process(clk, rst) is
	begin
		if rst = '1' then
			current_state <= IDLE; 	
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process;
	
	
	-- state sequency logic
	state_logic: process (current_state, samples, en)
	begin
		local_rst <= '0';
		filter_done <= '0';
		
		case current_state is 
			when IDLE =>
				local_rst <= '1';								
				if en = '1' then
					next_state <= RED_FILTER;
				else
					next_state <= IDLE;				
				end if;
				
			when RED_FILTER =>
				
				if (samples > SAMPLES_PER_FILTER -1) then
					next_state <= BLUE_FILTER;
					local_rst <= '1';
					filter_done <= '1';
				else
					next_state <= RED_FILTER;
				end if;
					
			when BLUE_FILTER =>				
				if (samples > SAMPLES_PER_FILTER -1) then				
					next_state <= GREEN_FILTER;
					local_rst <= '1';
					filter_done <= '1';
				else
					next_state <= 	BLUE_FILTER;					
				end if;
			when GREEN_FILTER =>				
				if (samples > SAMPLES_PER_FILTER -1) then					
					next_state <= READY;
					local_rst <= '1';
					filter_done <= '1';
				else
					next_state <= GREEN_FILTER;												
				end if;
			when READY =>
				--if en = '1' then
				--	next_state <= RED_FILTER;
				--else
					next_state <= IDLE;					
				--end if;		
		end case;		
	end process;
	
	-- samples per filter counter
	sample_counter: process (clk, rst)
	begin
		if rst = '1' then
			samples <= 0;
		else
			if rising_edge(clk) then
				if local_rst = '0' then
					samples <= samples + 1;
				else
					samples <= 0;
				end if;
			end if;
		end if;	
		
	end process;
	
	-- Moore output logic
	moore_output: process (current_state)
	begin
		filter_sel <= NO_FILTER_SEL; 
		done <= '0';
		reload_reg <= '0';
		
		case current_state is 
			when IDLE =>
				reload_reg <= '1';
			when RED_FILTER =>
				filter_sel <= RED_FILTER_SEL;
			when BLUE_FILTER =>
				filter_sel <= BLUE_FILTER_SEL;				
			when GREEN_FILTER =>
				filter_sel <= GREEN_FILTER_SEL;	
			when READY =>
				done <= '1';			
		end case;
		
	end process;
	

end architecture RTL;
