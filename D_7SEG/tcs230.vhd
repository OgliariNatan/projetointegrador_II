-- *
-- * tcs230.vhd
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

entity tcs230 is
	
	generic (
		SHIFT_BITS	: integer := 8		-- 2**SHIFT_BITS is the number of samples before color detection: validated with 8
	);
	
	port(
		clk_50Mhz : in std_logic;			-- 50MHz input clock
		rst : in std_logic;			-- input clock
		
		data_in : in std_logic;		-- sensor data input
		
		freq_sel : in std_logic_vector(1 downto 0); 
		-- freq_sel
		-- "00" Power down
		-- "10" 002% 	010~012 kHz
		-- "01" 020%	100~120 kHz
		-- "11" 100%	500~600 kHz   <--- Validated 		
		
		s_out   : out std_logic_vector(3 downto 0);	-- Filter selection
		red 	: out std_logic;							-- '1' if red is detected
		blue 	: out std_logic;							-- '1' if blue is detected
		green	: out std_logic;								-- '1' if green is detected	
		cor_ok : out std_logic
	);
end entity tcs230;


architecture RTL of tcs230 is
	
	component pll
	port
	(
		areset		: in std_logic  := '0';
		inclk0		: in std_logic  := '0';
		c0		: out std_logic 
	);
	end component;
	
	component fsm
	generic (		
		SAMPLES_PER_FILTER : integer	
	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		en : in std_logic;
		filter_sel : out std_logic_vector(1 downto 0);
		filter_done : out std_logic;
		reload_reg : out std_logic;
		done : out std_logic
	);
	end component fsm;
	
	component debug_ram
	port
	(
		address		: in std_logic_vector (4 downto 0);
		clock		: in std_logic  := '1';
		data		: in std_logic_vector (31 downto 0);
		wren		: in std_logic ;
		q		: out std_logic_vector (31 downto 0)
	);
	end component;
	
	
	component freq_counter
	port(
		clk : in std_logic;
		rst : in std_logic;
		
		pulse	: in std_logic;
		err		: out std_logic;
		
		data_out : out std_logic_vector(15 downto 0)
	);
	end component;

	constant SAMPLES_PER_FILTER : integer := 2**(SHIFT_BITS);

	constant RED_FILTER_SEL : std_logic_vector(1 downto 0) := "00";
	constant BLUE_FILTER_SEL : std_logic_vector(1 downto 0) := "10";
	constant GREEN_FILTER_SEL : std_logic_vector(1 downto 0) := "11";
	constant NO_FILTER_SEL : std_logic_vector(1 downto 0) := "01";	

	signal err, filtered : std_logic;
	signal address : std_logic_vector (4 downto 0);
	
	signal freq : std_logic_vector(15 downto 0);
	signal data,q : std_logic_vector(31 downto 0);
	
	signal freq_red_acc :  std_logic_vector(23 downto 0);
	signal freq_blue_acc :  std_logic_vector(23 downto 0);
	signal freq_green_acc :  std_logic_vector(23 downto 0);
	signal filter_sel	: std_logic_vector(1 downto 0);
	signal done : std_logic;
	signal reload : std_logic;
	
	signal r,g,b : std_logic;
	signal clk : std_logic;
	
begin

	-- 50MHz to 1MHz PLL
	pll_0: pll port map(
		areset => rst,
		inclk0 => clk_50Mhz,
		c0 => clk
	);
	
	-- clk <= clk_50Mhz;

	-- generate address for debug_ram
	process(clk, rst)
	begin
		if (rst = '1') then
			address <= (others => '0');
		else
			if rising_edge(clk) and done = '1' then
				address <= address + 1;
			end if;
		end if;	
	end process;

	-- data for in-system memory content editor (DEBUGING purpose)
	data <= "00000" & g & b & r & 
		freq_green_acc(SHIFT_BITS-1 downto 0) & 
		freq_blue_acc(SHIFT_BITS-1 downto 0) & 
		freq_red_acc(SHIFT_BITS-1 downto 0);
	
	
	dbg_ram: debug_ram
	port map (
		address	=> address,
		clock		=> clk,
		data		=> data,
		wren		=> done,
		q			=> q
	);

	-- count frequency
	freq_0: freq_counter
		port map(
			clk      => clk,
			rst      => rst,
			pulse    => data_in,
			err      => err,
			data_out => freq
		);
	
	-- finite state machine for filtering, sampling and registering
	ctrl: fsm
		generic map (
			SAMPLES_PER_FILTER => SAMPLES_PER_FILTER
		)	
		port map(
			clk => clk,
			rst => rst,
			en  => '1',
			filter_sel => filter_sel,
			filter_done => filtered,
			reload_reg => reload,
			done => done
		);
	
	s_out(3 downto 2) <= filter_sel;
	
	
	-- signal filtering process
	acc:process (clk, rst, reload)
	begin
		if rst = '1'  then
			freq_red_acc <= (others => '0');
			freq_blue_acc <= (others => '0');
			freq_green_acc <= (others => '0');
		else
			if rising_edge(clk) then				
				if reload = '1' then				
					freq_red_acc <= (others => '0');
					freq_blue_acc <= (others => '0');
					freq_green_acc <= (others => '0');		
				elsif filtered = '0' then
					case filter_sel is
						when RED_FILTER_SEL =>
							freq_red_acc <= freq_red_acc + freq;						
						when BLUE_FILTER_SEL =>
							freq_blue_acc <= freq_blue_acc + freq;						
						when GREEN_FILTER_SEL =>
							freq_green_acc <= freq_green_acc + freq;
						when others =>	
						
					end case;
							
				else					
					if filter_sel = RED_FILTER_SEL then					
						freq_red_acc <= x"00" & freq_red_acc(23 downto SHIFT_BITS);
					end if;
					
					if filter_sel = BLUE_FILTER_SEL then
						freq_blue_acc <= x"00" & freq_blue_acc(23 downto SHIFT_BITS);
					end if;
					
					if filter_sel = GREEN_FILTER_SEL then
						freq_green_acc <= x"00" & freq_green_acc(23 downto SHIFT_BITS);
					end if;				
				end if;
					
			end if;
		end if;
	end process;
	
	red <= r;
	blue <= b;
	green <= g;
	
	-- color detection
	color_dection: process (clk, rst, done)
	begin
		if rst = '1' then
			r <= '0';
			b <= '0';
			g <= '0';
		else			
			if rising_edge(clk) and done = '1' then
				if ((freq_red_acc < freq_blue_acc) and 
					(freq_red_acc < freq_green_acc)) and
					(freq_red_acc > x"32") then
					r <= '1';
					b <= '0';
					g <= '0';
				elsif ((freq_blue_acc < freq_red_acc) and
					(freq_blue_acc < freq_green_acc)) then 
					-- (freq_blue_acc < x"80") then
					r <= '0';
					b <= '1';
					g <= '0';
				elsif ((freq_green_acc < freq_red_acc) and
					(freq_green_acc < freq_blue_acc)) then
					r <= '0';
					b <= '0';
					g <= '1';					
				else
					r <= '0';
					b <= '0';
					g <= '0';
				end if;	 
			end if;
		end if;
	end process;	
	
	s_out(1 downto 0) <= freq_sel;
	

end architecture RTL;


