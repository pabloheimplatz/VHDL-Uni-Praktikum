-- tstClock.vhd					AJM : 16.01.2003
--
-- entity	tstClock
--			-top-level testbench, entity:	clock
--			-			-"-	dcf77
-- architecture	stimuli
--
-- note			-the top-level declaration and instantiation
--			 has to be modified!!
--			-the stimuli generation is for the sample push-button
--			 interface: set_time/set_ala + set_mins/set_hrs
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tstClock is
generic (	tClk	: time		:= 1 us);	-- 1 MHz
end entity tstClock;


architecture stimuli of tstClock is
  -- component decl.	------------------------------------------------------
  ----------------------------------------------------------------------------
  component dcf77 is
  generic (	tDelay	: time		:= 300 us;	-- initial Delay
		tSample	: time		:=   1 ms);	-- 1 kHz sample freq.
  port	(	dcfsig	: out std_logic;		-- DCF77 signal
		mins	: in  integer range 0 to 59	:= 34;
		hours	: in  integer range 0 to 23	:= 12;
		wday	: in  integer range 1 to  7	:= 1;
		day	: in  integer range 1 to 31	:= 25;
		month	: in  integer range 1 to 12	:= 11;
		year	: in  integer range 0 to 99	:= 2;
		noise	: in  integer range 0 to 50	:= 0;
		xtra	: in  std_logic_vector (15 to 19):= "00000");
  end component dcf77;

  component clock is
  port(	reset		: in  std_logic;	-- async. reset		L
	clk1us		: in  std_logic;	-- 1 MHz clock		R
	dcfsig		: in  std_logic;	-- DCF77 signal
	set_time	: in  std_logic;	-- Set-Time   button	H
	set_alarm		: in  std_logic;	-- Set-Alarm  button	H
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
  end component clock;

  -- signal decl.	------------------------------------------------------
  ----------------------------------------------------------------------------
  signal reset		: std_logic := '0';
  signal clk1us		: std_logic := '0';
  signal dcfSig		: std_logic;
  signal butTime	: std_logic := '0';
  signal butAla		: std_logic := '0';
  signal butMins	: std_logic := '0';
  signal butHrs		: std_logic := '0';
  signal butAlarm	: std_logic := '0';
  signal butDate	: std_logic := '0';
  signal butWDay	: std_logic := '0';
  signal seldgt		: std_logic_vector (5 downto 0);
  signal decoded	: std_logic_vector (6 downto 0);
  signal alarmLed	: std_logic;
  signal alarmRing	: std_logic;
  signal dcfsok		: std_logic;


begin
  -- instances		------------------------------------------------------
  ----------------------------------------------------------------------------
  clockI: clock
    port map	(reset, clk1us, dcfSig,
		 butTime, butAla, butMins, butHrs, butAlarm, butDate, butWDay,
		 seldgt, decoded, alarmLed, alarmRing, dcfsok);

  -- default time: 12:34, Mo. 25.11.02		------------------------------
  dcf77I: dcf77
    generic map	(tDelay => 1987654 us)		-- async. start, long pause
    port map	(dcfSig);
 
  -- processes		------------------------------------------------------
  ----------------------------------------------------------------------------

  -- clock, period: tClk 			------------------------------
  clkP: process
  begin
	clk1us <= '0';	wait for tClk/2;	-- 0.5 us
	clk1us <= '1';	wait for tClk/2;	-- 0.5 us
  end process clkP;
 
  -- reset, trigger				------------------------------
  rstP: process
  begin
	reset <= '1';	wait for tClk/10;	-- 0.1 us
	reset <= '0';	wait for tClk/5;	-- 0.2 us
	reset <= '1';	wait for tClk/2;	-- 0.5 us
	wait on reset;
  end process rstP;

  -- stimuli generator				------------------------------
  stiP: process
    -- local (overloaded) procedures		------------------------------
    procedure pushBut(	pushT, runT		: in time;
			signal but		: out std_logic) is
    begin
      but <= '1';	wait for pushT;
      but <= '0';	wait for runT-pushT;
    end procedure pushBut;			-- one button

    procedure pushBut(	pushT, runT		: in time;
			signal but1, but2	: out std_logic) is
    begin
      but1 <= '1';
      but2 <= '1';	wait for pushT;
      but1 <= '0';
      but2 <= '0';	wait for runT-pushT;
    end procedure pushBut;			-- two buttons
  begin
    -- send pattern:	12:34, Mo. 25.11.02	-- <action>    <time-Sum>
    wait for 1 sec;				--		 1

    -- set alarm: 	12:34
    pushBut( 6 sec,  7 sec, butAla, butHrs);	-- hour   +12	 8
    pushBut(17 sec, 18 sec, butAla, butMins);	-- minute +34	26

    -- activate alarm
    pushBut(300 ms, 1 sec, butAlarm);		-- alarm on	27

    -- set time: 	06:08
    pushBut( 3 sec,  4 sec, butTime, butHrs);	-- hour   + 3	31
    pushBut( 4 sec,  5 sec, butTime, butMins);	-- minute + 4	36

    -- run for 28 sec., synchronisation at tDelay + 60 sec. =>  62
    wait for 28 sec;				--		(64) -> 02

    -- stop alarm
    pushBut(300 ms, 1 sec, butAlarm);		-- alarm off	(65) -> 03

    wait;
  end process stiP;

end architecture stimuli;
 
-- configuration	------------------------------------------------------
------------------------------------------------------------------------------
configuration cfgClock of tstClock is
for stimuli
end for;
end configuration cfgClock;

