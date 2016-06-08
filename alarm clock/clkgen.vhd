-- clkgen.vhd					AJM : 25.11.2002
--
-- entity	clkgen	-clock-generator
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity clkgen is
  port( reset		: in  std_logic;	--async. reset		L
--	dcfload		: in  std_logic;	--load DCF/clock sync.	H
	clk1us		: in  std_logic;	--1MHz clock		R
	clk1ms		: out std_logic;	--1KHz clock		R
	clk500ms	: out std_logic;	--2Hz  clock		R
	clk1s		: out std_logic);	--1Hz  clock		R
end entity clkgen;

architecture behave of clkgen is

signal count1ms : integer range 0 to 999 := 0;
signal count500ms : integer range 0 to 499 := 0;
signal count1s : integer range 0 to 999 := 0;

signal tmpclk1ms : std_logic; -- tmp clk1ms OUT mapping
signal tmpclk500ms : std_logic; -- tmp clk500ms OUT mapping
signal tmpclk1s : std_logic; -- tmp clk1s OUT mapping

begin

clk1ms <= tmpclk1ms;
clk500ms <= tmpclk500ms;
clk1s <= tmpclk1s;

-- http://vhdlguru.blogspot.de/2010/03/digital-clock-in-vhdl.html 
-- generate a 1ms clock
gen1ms: process(reset, clk1us)
begin
   if reset='0' then 
      count1ms <= 0;
      tmpclk1ms <= '0';
   elsif clk1us='1' and clk1us'event then
		if(count1ms = 499) then
			tmpclk1ms <= not tmpclk1ms;
			count1ms <= 0;
		else
			count1ms <= count1ms+1;
		end if;
	end if;
end process;

-- generate a 500ms clock
gen500ms: process(reset, tmpclk1ms)
begin
  	if reset='0' then 
      count500ms <= 0;
      tmpclk500ms <= '0';
      count1s <= 0;
      tmpclk1s <= '0';
	elsif tmpclk1ms='1' and tmpclk1ms'event then
		if(count500ms = 249) then
			tmpclk500ms <= not tmpclk500ms;
			count500ms <= 0;
			count1s <= count1s+1;
		else
			count500ms <= count500ms+1;
			count1s <= count1s+1;
		end if;
		if(count1s = 499) then
			tmpclk1s <= not tmpclk1s;
			count1s <= 0;
		end if;
	end if;
end process;

-- generate a 1s clock
--gen1s: process(reset, tmpclk1s)
--begin
--  	if reset='0' then 
--      count1s <= 0;
--      tmpclk1s <= '0';
--	elsif tmpclk500ms='1' and tmpclk500ms'event then
--		if(count1s = 50) then
--			tmpclk1s <= not tmpclk1s;
--			count1s <= 0;
--		else
--			count1s <= count1s+50;
--		end if;
--	end if;
-- end process;

end architecture behave;