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
