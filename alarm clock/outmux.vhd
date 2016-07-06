-- outmux.vhd					AJM : 25.11.2002
--
-- entity	outmux	-output multiplexor: segment decoder + digit driver
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity outmux is
  port( reset		: in std_logic;		--async. reset		L
	clk1ms		: in std_logic;		--1KHz clock		R
	set_alarm	: in std_logic;		--Set-Alarm   button	H
--	disp_wday	: in std_logic;		--Displ.-WDay button	H
--	disp_date	: in std_logic;		--Displ.-Date button	H
--	dcfload		: in std_logic;		--load DCF-date		H
--	dcfsok		: in std_logic;		--signal quality	H
--	dcf_wday	: in unsigned (2 downto 0);	--		BCD
--	dcf_day1	: in unsigned (3 downto 0);	--		BCD
--	dcf_day10	: in unsigned (1 downto 0);	--		BCD
--	dcf_month1	: in unsigned (3 downto 0);	--		BCD
--	dcf_month10	: in std_logic;			--		BCD
--	dcf_year1	: in unsigned (3 downto 0);	--		BCD
--	dcf_year10	: in unsigned (3 downto 0);	--		BCD
	tim_secs1	: in unsigned (3 downto 0);	--		BCD
	tim_secs10	: in unsigned (2 downto 0);	--		BCD
	tim_mins1	: in unsigned (3 downto 0);	--		BCD
	tim_mins10	: in unsigned (2 downto 0);	--		BCD
	tim_hrs1	: in unsigned (3 downto 0);	--		BCD
	tim_hrs10	: in unsigned (1 downto 0);	--		BCD
	ala_mins1	: in unsigned (3 downto 0);	--		BCD
	ala_mins10	: in unsigned (2 downto 0);	--		BCD
	ala_hrs1	: in unsigned (3 downto 0);	--		BCD
	ala_hrs10	: in unsigned (1 downto 0);	--		BCD
	seldgt		: out std_logic_vector (5 downto 0);  --digit lines
	decoded		: out std_logic_vector (6 downto 0)); --7 Seg. output
end entity outmux;

architecture behave of outmux is

  component bcddec is
  port( bcdin	: in  std_logic_vector (3 downto 0);  --BCD input      MSB-left
	decoded	: out std_logic_vector (6 downto 0)); --7 Seg. output  a..g
  end component bcddec;
	
  signal bcdin	 : std_logic_vector (3 downto 0);  --BCD input      MSB-left
  signal counter : std_logic_vector (5 downto 0); --7 Seg. output
 
  begin 
 	bcddec_comp: bcddec port map (bcdin, decoded);

 	seldgt <= counter;

	check_alarm: process(reset, clk1ms, set_alarm)
	begin
		if reset = '0' then
			-- reset case
			counter <= "100000";
			bcdin <= "0000";
		elsif rising_edge(clk1ms) then
			counter <= counter(4 downto 0) & counter(5);

			if set_alarm = '1' then
				-- aktuelle Alarm Zeit anzeigen
					case counter is
					when "000001" => bcdin <= "0000";
					when "000010" => bcdin <= "0000";
					when "000100" => bcdin <= std_logic_vector(ala_mins1);
					when "001000" => bcdin <= '0' & std_logic_vector(ala_mins10);
					when "010000" => bcdin <= std_logic_vector(ala_hrs1);
					when "100000" => bcdin <= '0' & '0' & std_logic_vector(ala_hrs10);
					when others => bcdin <= "0000";
					end case;

			else
				-- Uhrzeit zeigen bei set_alarm = '0'
					case counter is
					when "000001" => bcdin <= '0' & std_logic_vector(tim_secs1);
					when "000010" => bcdin <= '0' & '0' & std_logic_vector(tim_secs10);
					when "000100" => bcdin <= std_logic_vector(tim_mins1);
					when "001000" => bcdin <= '0' & std_logic_vector(tim_mins10);
					when "010000" => bcdin <= std_logic_vector(tim_hrs1);
					when "100000" => bcdin <= '0' & '0' & std_logic_vector(tim_hrs10);
					when others => bcdin <= "0000";
					end case;
			end if;
		end if;
	end process check_alarm;

end architecture behave;