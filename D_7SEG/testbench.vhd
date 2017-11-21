-- Insert library and use clauses
library ieee;
use IEEE.std_logic_textio.all;  
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;


ENTITY testbench IS
	generic (
         ASIZE          : integer := 23;
         DSIZE          : integer := 32;
         ROWSIZE        : integer := 13;
         COLSIZE        : integer := 9;
         BANKSIZE       : integer := 2;
         ROWSTART       : integer := 9;
         COLSTART       : integer := 0;
         BANKSTART      : integer := 20;
			
			
		 DATA_ADDR_SIZE : integer := 32;
		 WORD_SIZE 			: integer := 32;
       	
			
		-- SDRAM latencies
		DATA_AVAL			: integer := 2;	-- cycles
		RESET_NOP		: integer := 4;	-- cycles
		RAS_TO_CAS		: integer := 2;	-- cycles			
		PRE_TO_ACT		: integer := 3		-- cycles
    );


END ENTITY testbench;

ARCHITECTURE stimulus OF testbench IS
	

	component tcs230
	port (
	    clk : in std_logic;
		rst : in std_logic;
		
		freq_sel : in std_logic_vector(1 downto 0);
		
		s_out   : out std_logic_vector(3 downto 0);	-- Filter selection
		data_in : in std_logic	-- sensor data input
	);
	end component;
		
	signal clk : std_logic;
	signal reset : std_logic;
		
	signal s : std_logic_vector(3 downto 0);
	signal data : std_logic;
	
	signal data_0, data_1, sel : std_logic;
	
	
BEGIN  -- beginning of architecture body
	
	
	tcs230_0: tcs230 port map (
		clk => clk,
		rst => reset,
		freq_sel => "11",
		s_out => s,
		data_in => data 
	);			
				
	-- Process to create clock signal -- 50Mhz
	clk_proc : process
	begin
		clk <= '0';
		wait for 500 ns;		
		clk <= '1';
		wait for 500 ns;
	end process;


	reset_p : process
	begin
		reset <= '1';				
		WAIT FOR 1 us;
		reset <= '0';		
		wait;
	end process;
	
	
	data_sim_f0: process
	begin
		data_0 <= '0';
		wait for 2 us;		
		data_0 <= '1';
		wait for 2 us;
	end process;
	
	data_sim_f1: process
	begin
		data_1 <= '0';
		wait for 1 us;		
		data_1 <= '1';
		wait for 1 us;
	end process;
	
	--LCD_EN	<= '1'  when (enable = '1') and count = 1 else '0';	
	
	sel <= '0', '1' AFTER 40 us;
	
	data <= data_0 when (sel = '0') else data_1;
	
			
END ARCHITECTURE stimulus;
