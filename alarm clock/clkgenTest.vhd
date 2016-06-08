library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clkgenTest is
generic( timeslot: time := 1 us);
end entity clkgenTest;

architecture testbench of clkgenTest is

	component clkgen is
	port(reset		: in  std_logic;	--async. reset		L
		clk1us		: in  std_logic;	--1MHz clock		R
		clk1ms		: out std_logic;	--1KHz clock		R
		clk500ms	: out std_logic;	--2Hz  clock		R
		clk1s		: out std_logic);	--1Hz  clock		R
	end component clkgen;

	signal reset		:  std_logic;	--async. reset		L
	signal clk1us		:  std_logic;	--1MHz clock		R
	signal clk1ms		:  std_logic;	--1KHz clock		R
	signal clk500ms		:  std_logic;	--2Hz  clock		R
	signal clk1s		:  std_logic;	--1Hz  clock		R

begin
	x : clkgen port map ( reset, clk1us, clk1ms, clk500ms, clk1s);
	clck: process is
	begin
		clk1us <= '1', '0' after timeslot/2;
		wait for timeslot;
	end process clck;
		reset <= '0', '1' after timeslot/4;


end architecture testbench;