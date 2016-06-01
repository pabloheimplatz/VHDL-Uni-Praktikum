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
