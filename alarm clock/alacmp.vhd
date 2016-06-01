-- alacmp.vhd					AJM : 25.11.2002
--
-- entity	alacmp	-alarm comparator
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alacmp is
  port( ala_mins1	: in unsigned (3 downto 0);  --			BCD
	ala_mins10	: in unsigned (2 downto 0);  --			BCD
	ala_hrs1	: in unsigned (3 downto 0);  --			BCD
	ala_hrs10	: in unsigned (1 downto 0);  --			BCD
	tim_mins1	: in unsigned (3 downto 0);  --			BCD
	tim_mins10	: in unsigned (2 downto 0);  --			BCD
	tim_hrs1	: in unsigned (3 downto 0);  --			BCD
	tim_hrs10	: in unsigned (1 downto 0);  --			BCD
	compare		: out std_logic);	--is alarm time		H
end entity alacmp;

architecture alarm_time_compare of alacmp is
	begin
	compare_time: process(ala_mins1, ala_mins10, ala_hrs1, ala_hrs10, tim_mins1, tim_mins10, tim_hrs1, tim_hrs10)
	begin
		compare = '0';
		if ala_mins1 = tim_mins1 and ala_mins10 = tim_mins10 and ala_hrs1 = tim_hrs1 and ala_hrs10 = tim_hrs10 then
			compare = '1';
		end if;
	end process;
	
end architecture alarm_time_compare;
