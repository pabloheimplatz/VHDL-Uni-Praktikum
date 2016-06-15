-- clock.vhd					AJM : 16.01.2003
--
-- entity	clock	-top-level structure
-- architecture
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity clock is
  port(	reset		: in  std_logic;	-- async. reset		L
	clk1us		: in  std_logic;	-- 1 MHz clock		R
	dcfsig		: in  std_logic;	-- DCF77 signal
	set_time	: in  std_logic;	-- Set-Time   button	H
	set_ala		: in  std_logic;	-- Set-Alarm  button	H
	set_mins	: in  std_logic;	-- Set-Min    button	H
	set_hrs		: in  std_logic;	-- Set-Hour   button	H
	alarm_tog	: in  std_logic;	-- alarm      button	H
	disp_date	: in  std_logic;	-- date       button	H
	disp_wday	: in  std_logic;	-- weekday    button	H
	seldgt		: out std_logic_vector (5 downto 0);	--digit lines	
	decoded		: out std_logic_vector (6 downto 0);	--7 Seg output
	alarm_act	: out std_logic;	-- alarm LED on		H
	alarm_out	: out std_logic;	-- alarm ringer		H
	dcfsok		: out std_logic);	-- signal quality	H
end entity clock;

architecture behave of clock is

component timblk is
	port (reset		: in std_logic;		--async. reset		L
	clk500ms	: in std_logic;		--2Hz clock		R
	clk1s		: in std_logic;		--1Hz clock		R
	set_time	: in std_logic;		--Set-Time   button	H
-- if 0 die Uhrzeit wird im Sekundentakt raufgezählt (Modulo-Zähler)	
-- if 1 setze Sekunden auf "00" zurück. Und bereite das manuelle Stellen vor
	set_mins	: in std_logic;		--Set-Min    button	H
	set_hrs		: in std_logic;		--Set-Hours  button	H
--	dcfload		: in std_logic;		--load DCF-time		H
--	dcf_mins1	: in unsigned (3 downto 0);	 --		BCD
--	dcf_mins10	: in unsigned (2 downto 0);	 --		BCD
--	dcf_hrs1	: in unsigned (3 downto 0);	 --		BCD
--	dcf_hrs10	: in unsigned (1 downto 0);	 --		BCD
	tim_secs1	: buffer unsigned (3 downto 0);	 --		BCD
	tim_secs10	: buffer unsigned (2 downto 0);	 --		BCD
	tim_mins1	: buffer unsigned (3 downto 0);	 --		BCD
	tim_mins10	: buffer unsigned (2 downto 0);	 --		BCD
	tim_hrs1	: buffer unsigned (3 downto 0);	 --		BCD
	tim_hrs10	: buffer unsigned (1 downto 0)); --		BCD)
end component timblk;

component alablk is
	port ( reset		: in std_logic;		--async. reset		L
	clk500ms	: in std_logic;		--2Hz clock		R
	set_alarm	: in std_logic;		--Set-Alarm  button	H
	set_mins	: in std_logic;		--Set-Min    button	H
	set_hrs		: in std_logic;		--Set-Hours  button	H
	ala_mins1	: buffer unsigned (3 downto 0);  --		BCD
	ala_mins10	: buffer unsigned (2 downto 0);  --		BCD
	ala_hrs1	: buffer unsigned (3 downto 0);  --		BCD
	ala_hrs10	: buffer unsigned (1 downto 0)); --		BCD)
end component alablk;

component clkgen is
	port ( reset		: in  std_logic;	--async. reset		L
--	dcfload		: in  std_logic;	--load DCF/clock sync.	H
	clk1us		: in  std_logic;	--1MHz clock		R
	clk1ms		: out std_logic;	--1KHz clock		R
	clk500ms	: out std_logic;	--2Hz  clock		R
	clk1s		: out std_logic);	--1Hz  clock		R)
end component clkgen;

component outmux is
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
	decoded		: out std_logic_vector (6 downto 0)); --7 Seg. output)
end component outmux;

component bcddec is
	port( bcdin	: in  std_logic_vector (3 downto 0);  --BCD input      MSB-left
	decoded	: out std_logic_vector (6 downto 0)); --7 Seg. output  a..g
end component bcddec;

component alacmp is
	port( ala_mins1	: in unsigned (3 downto 0);  --			BCD
	ala_mins10	: in unsigned (2 downto 0);  --			BCD
	ala_hrs1	: in unsigned (3 downto 0);  --			BCD
	ala_hrs10	: in unsigned (1 downto 0);  --			BCD
	tim_mins1	: in unsigned (3 downto 0);  --			BCD
	tim_mins10	: in unsigned (2 downto 0);  --			BCD
	tim_hrs1	: in unsigned (3 downto 0);  --			BCD
	tim_hrs10	: in unsigned (1 downto 0);  --			BCD
	compare		: out std_logic);	--is alarm time		H)
end component alacmp;

component alafsm is
	port( reset		: in  std_logic;	--async. reset		L
	clk1ms		: in  std_logic;	--1KHz clock		R
	alarm_tog	: in  std_logic;	--toggle-alarm		H
	compare		: in  std_logic;	--is alarm time		H
	alarm_act	: out std_logic;	--alarm LED on		H
	alarm_out	: out std_logic);	--alarm ringer		H)
end component alafsm;


signal clk1ms		: std_logic;	--1KHz clock		R
signal clk500ms	: std_logic;	--2Hz  clock		R
signal clk1s		: std_logic;	--1Hz  clock		R)
signal tim_secs1	: unsigned (3 downto 0);	--		BCD
signal tim_secs10	: unsigned (2 downto 0);	--		BCD
signal tim_mins1	: unsigned (3 downto 0);	--		BCD
signal tim_mins10	: unsigned (2 downto 0);	--		BCD
signal tim_hrs1	: unsigned (3 downto 0);	--		BCD
signal tim_hrs10	: unsigned (1 downto 0);	--		BCD
signal ala_mins1	: unsigned (3 downto 0);	--		BCD
signal ala_mins10	: unsigned (2 downto 0);	--		BCD
signal ala_hrs1	: unsigned (3 downto 0);	--		BCD
signal ala_hrs10	:  unsigned (1 downto 0);	--		BCD
signal compare		:  std_logic;	--is alarm time		H)

begin
	outmux_mapping: outmux port map (reset, clk1ms, set_alarm, tim_secs1, tim_secs10, tim_mins1, tim_mins10, tim_hrs1, tim_hrs10, ala_mins1, ala_mins10, ala_hrs1, ala_hrs10, seldgt, decoded);

	alacmp_mapping: alacmp port map (ala_mins1, ala_mins10, ala_hrs1, ala_hrs10, tim_mins1, tim_mins10, tim_hrs1, tim_hrs10, compare);

	alafsm_mapping: alafsm port map (reset, clk1ms, alarm_tog, compare, alarm_act, alarm_out);

	clkgen_mapping: clkgen port map(reset, clk1us, clk1ms, clk500ms, clk1s);

	alablk_mapping: alablk port map(reset, clk500ms, set_alarm, set_mins, set_hrs, ala_mins1, ala_mins10, ala_hrs1, ala_hrs10);

	timblk_mapping: timblk port map(reset, clk500ms, clk1s, set_time, set_mins, set_hrs, tim_secs1, tim_secs10, tim_mins1, tim_mins10, tim_hrs1, tim_hrs10, ala_mins1, ala_mins10, ala_hrs1, ala_hrs10);

end architecture behave;


