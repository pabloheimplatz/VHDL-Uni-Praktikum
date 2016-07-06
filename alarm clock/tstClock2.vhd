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

entity tstClock2 is
generic (	tClk	: time		:= 1 us);	-- 1 MHz
end entity tstClock2;


architecture stimuli of tstClock2 is

  component clock is
  port( reset   : in  std_logic;  -- async. reset   L
        clk1us    : in  std_logic;  -- 1 MHz clock    R
        dcfsig    : in  std_logic;  -- DCF77 signal
        set_time  : in  std_logic;  -- Set-Time   button  H
        set_alarm   : in  std_logic;  -- Set-Alarm  button  H
        set_mins  : in  std_logic;  -- Set-Min    button  H
        set_hrs   : in  std_logic;  -- Set-Hour   button  H
        alarm_tog : in  std_logic;  -- alarm      button  H
        disp_date : in  std_logic;  -- date       button  H
        disp_wday : in  std_logic;  -- weekday    button  H
        seldgt    : out std_logic_vector (5 downto 0);  --digit lines 
        decoded   : out std_logic_vector (6 downto 0);  --7 Seg output
        alarm_act : out std_logic;  -- alarm LED on   H
        alarm_out : out std_logic;  -- alarm ringer   H
        dcfsok    : out std_logic); -- signal quality H)
  end component clock;

  signal reset      : std_logic;
  signal clk1us     : std_logic;
  signal dcfsig     : std_logic;
  signal set_time   : std_logic;
  signal set_alarm  : std_logic;
  signal set_mins   : std_logic;
  signal set_hrs    : std_logic;
  signal alarm_tog  : std_logic;
  signal disp_date  : std_logic;
  signal disp_wday  : std_logic;
  signal seldgt     : std_logic_vector (5 downto 0);
  signal decoded    : std_logic_vector (6 downto 0);
  signal alarm_act  : std_logic;
  signal dcfsok     : std_logic;

begin
  -- clock mapping
  mapping : clock port map (reset, clk1us, dcfsig, set_time, set_alarm, set_mins, set_hrs, alarm_tog, disp_date, disp_wday, seldgt, decoded, alarm_act, dcfsok);
  
  reset <= '0', '1' after tClk/4;


  -- Clock
  clck: process is
  begin
    clk1us <= '1', '0' after tClk/2;
    wait for tClk;
  end process clck;

  -- Testfall - Uhr stellen
  test1: process is
  begin
    set_time <= '0';
    set_alarm <= '0';
  end process 

end architecture stimuli;

