-- alablk.vhd					AJM : 25.11.2002
--
-- entity	alablk	-alarm-counter and register
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alablk is
  port( reset		: in std_logic;		--async. reset		L
	clk500ms	: in std_logic;		--2Hz clock		R
	set_alarm	: in std_logic;		--Set-Alarm  button	H
	set_mins	: in std_logic;		--Set-Min    button	H
	set_hrs		: in std_logic;		--Set-Hours  button	H
	ala_mins1	: buffer unsigned (3 downto 0);  --		BCD
	ala_mins10	: buffer unsigned (2 downto 0);  --		BCD
	ala_hrs1	: buffer unsigned (3 downto 0);  --		BCD
	ala_hrs10	: buffer unsigned (1 downto 0)); --		BCD
end entity alablk;

architecture alarm of alablk is
	begin
		alarm_setting: process (reset, clk500ms, set_mins, set_hrs)
		begin
			if reset = '0' then
				ala_mins1 <= "0000";
				ala_mins10 <= "000";
				ala_hrs1 <= "0000";
				ala_hrs10 <= "00";
			elsif set_alarm='1' then
				if rising_edge(clk500ms) then
					if set_hrs '1' then
						ala_hrs1 =  "0000";
						ala_hrs10 <= ala_hrs10 + 1;
					elsif ala_hrs10 = 1 and ala_hrs1 = 2 then
						ala_hrs10 =  "00";
						ala_hrs1 = "0000";
					end if;
	  			elsif set_mins= '1' then
	  				ala_mins1 <= ala_mins1 + 1;
	  				if ala_mins1 = 9 then
  		  		 	  ala_mins1 =  "0000";
  		  			  ala_mins10 <= ala_mins10 + 1;
  		  				if ala_mins10 = 5 then
  		  		 	 	  ala_mins10 =  "000";
  		  		 	 	end if;
  		  		 	end if;
  		  		end if;
			end if;
		end process;

end architecture alarm;