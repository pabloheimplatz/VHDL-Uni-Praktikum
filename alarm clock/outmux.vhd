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

begin

	check_alarm: process(reset, clk1ms, set_alarm)
	begin
		if rising_edge(clk1ms) then
			seldgt <= seldgt(4 downto 0) & seldgt(5);
			if reset = '0' then
				-- reset case
					case seldgt is
					when "00000" => decoded <= "1111110";
					when "00001" => decoded <= "1111110";
					when "00010" => decoded <= "1111110";
					when "00100" => decoded <= "1111110";
					when "01000" => decoded <= "1111110";
					when "10000" => decoded <= "1111110";
					when others => decoded <= "1111110";
					end case;
		
			elsif set_alarm = '1' then
				-- aktuelle Alarm Zeit anzeigen


			else
				-- Uhrzeit zeigen bei set_alarm = '0'
			end if;

		end if;
	end process;

	-- cases for seldgt im extra Prozess
	assign_seldgt: process(tim_secs1, tim_secs10, tim_mins1, tim_mins10, tim_hrs1, tim_hrs10)
	begin
	case seldgt is
	when "00000" =>
	when "00001" =>
	when "00010" =>
	when "00100" =>
	when "01000" =>
	when "10000" =>
	when others =>
	end case;
	end process;
end architecture behave;