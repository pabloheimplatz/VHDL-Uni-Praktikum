-- timblk.vhd					AJM : 25.11.2002
--
-- entity	timblk	-time-counter and register
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timblk is
  port( reset		: in std_logic;		--async. reset		L
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
	tim_hrs10	: buffer unsigned (1 downto 0)); --		BCD
end entity timblk;

architecture time of timblk is

  begin
  	time_null: process (reset, clk1s, set_time)
  	begin
 ---------------- 00:00:0x ----------------
  		if set_time='0' then
  		  if tim_secs1 < 9 then
  		  	tim_sec1 = "0000";
  		  	tim_sec10 <= tim_sec10 + 1;
---------------- 00:00:x0 ----------------
  		  	 	if tim_secs10 < 6 then
  				  tim_secs10 =  "000";
  		  		  tim_mins1 <= tim_mins1 + 1;
---------------- 00:0x:00 ----------------
  		  			if tim_mins1 < 9 then
  		  		 	  tim_min1 =  "0000";
  		  			  tim_mins10 <= tim_mins10 + 1;

  		  end if;
  		end if;
  	end process;

  	time_one: process (reset, clk500ms, clk1s, set_time, set_mins, set_hrs)
  	begin
  		if set_time='1' then
  		  tim_secs1 <= '0000';
  		  tim_secs10 <= '000';
  		  set_time ='1';
  		end if;
   	end process;

  	time_hrs: process (clk500ms, set_time, set_hrs)
  	begin
  		if set_time='1' and set_hrs'1' then
  		-- TO DO
  		end if;
   	end process;

   	 time_mins: process (clk500ms, set_time, set_mins)
  	begin
  		if set_time='0' and set_mins='1' then
  		-- TO DO
  		end if;
   	end process;

end architecture time;