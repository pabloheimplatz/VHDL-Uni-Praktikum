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
  	  if reset = '0' then
  	  	 tim_secs1 <= "0000";
  	  	 tim_secs10 <= "000";
  	  	 tim_mins1 <= "0000";
  	  	 tim_mins10 <= "000";
  	  	 tim_hrs1 <= "0000";
  	  	 tim_hrs10 <= "00";
  	  elsif set_time='0' then
  			if rising_edge(clk1s) then
  			  tim_secs1 = tim_secs1 + '1';
---------------- 00:00:09 ----------------
		  		 if tim_secs1 = 9 then
		  		  	tim_secs1 = "0000";
		  		  	tim_secs10 <= tim_secs10 + 1;
	---------------- 00:00:59 ----------------
	  		  	 	if tim_secs10 = 5
	  				  tim_secs10 =  "000";
	  		  		  tim_mins1 <= tim_mins1 + 1;
		---------------- 00:09:00 ----------------
	  		  			if tim_mins1 = 9 then
	  		  		 	  tim_mins1 =  "0000";
	  		  			  tim_mins10 <= tim_mins10 + 1;
			---------------- 00:59:00 ----------------
	  		  				if tim_mins10 = 5
	  		  		 	 	  tim_mins10 =  "000";
	  		  				  tim_hrs1 <= tim_hrs1 + 1;
				---------------- 09:00:00 ----------------
	  		  					if tim_hrs1 = 9 then
	  		  		 	 	  	  tim_hrs1 =  "0000";
	  		  				  	  tim_hrs10 <= tim_hrs10 + 1;
					---------------- 12:00:00 ----------------
	  		  					elsif tim_hrs10 = 1 and tim_hrs1 = 2 then
	  		  		 	 	  	  tim_hrs10 =  "00";
	  		  		 	 	  	  tim_hrs1 = "0000";
	  		  		 	 	  	end if;
	  		  		 	 	end if;
	  		  		 	end if;
	  		  		end if;
	  		  	end if;
  		    end if;
  		end if;
  	end process;

  	time_settings: process (clk500ms, set_time, set_hrs)
  	begin
  		if set_time= '1' 
			tim_secs1 <= "0000";
  			tim_secs10 <= "000";
  			if rising_edge(clk500ms) then
	  			if set_hrs= '1' then
	  				tim_hrs1 <=  tim_hrs1 + 1;
	  				if tim_hrs1 = 9 then
	  					tim_hrs1 =  "0000";
						tim_hrs10 <= tim_hrs10 + 1;
					elsif tim_hrs10 = 1 and tim_hrs1 = 2 then
						tim_hrs10 =  "00";
						tim_hrs1 = "0000";
					end if;
	  			elsif set_mins= '1' then
	  				tim_mins1 <= tim_mins1 + 1;
	  				if tim_mins1 = 9 then
  		  		 	  tim_mins1 =  "0000";
  		  			  tim_mins10 <= tim_mins10 + 1;
  		  				if tim_mins10 = 5
  		  		 	 	  tim_mins10 =  "000";
  		  		 	 	end if;
	  		  		end if;
	  		  	end if;
  			end if;
  		end if;
   	end process;

end architecture time;