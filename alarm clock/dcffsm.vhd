-- dcffsm.vhd					AJM : 25.11.2002
--
-- entity	dcffsm	-DCF77 decoder, state-machine
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dcffsm is
  port(	reset		: in  std_logic;	--async. reset		L
	clk1ms		: in  std_logic;	--1KHz clock		R
        dcfsig		: in  std_logic;	--input signal		DCF
	dcfsok		: out std_logic;	--signal quality	H
	dcfload		: out std_logic;	--load DCF-values	H
	dcf_mins1	: out unsigned (3 downto 0);	--		BCD
	dcf_mins10	: out unsigned (2 downto 0);	--		BCD
	dcf_hrs1	: out unsigned (3 downto 0);	--		BCD
	dcf_hrs10	: out unsigned (1 downto 0);	--		BCD
	dcf_wday	: out unsigned (2 downto 0);	--		BCD
	dcf_day1	: out unsigned (3 downto 0);	--		BCD
	dcf_day10	: out unsigned (1 downto 0);	--		BCD
	dcf_month1	: out unsigned (3 downto 0);	--		BCD
	dcf_month10	: out std_logic;		--		BCD
	dcf_year1	: out unsigned (3 downto 0);	--		BCD
	dcf_year10	: out unsigned (3 downto 0));	--		BCD
end entity dcffsm;
