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
