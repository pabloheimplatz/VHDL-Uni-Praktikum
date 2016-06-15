-- bcddec.vhd					AJM : 25.11.2002
--
-- entity	bcddec	-bcd to 7-segment decoder
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity bcddec is
  port( bcdin	: in  std_logic_vector (3 downto 0);  --BCD input      MSB-left
	decoded	: out std_logic_vector (6 downto 0)); --7 Seg. output  a..g
end entity bcddec;

architecture behave of bcddec is
--	type state is (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
--	signal cnt	: integer range 0 to 
--	signal curSt, nextSt	: state;

begin
	findNumber: process (bcdin) is
	begin
--	nextSt <= curSt;
	-- default constructor

	case bcdin is
	-- TODO: fix cases         abcdefg
	when "0000" => decoded <= "1111110";
	when "0001" => decoded <= "0000110";
	when "0010" => decoded <= "1101101";
	when "0011" => decoded <= "1111001";
	when "0100" => decoded <= "0110011";
	when "0101" => decoded <= "1011011";
	when "0110" => decoded <= "1011111";
	when "0111" => decoded <= "1110000";
	when "1000" => decoded <= "1111111";
	when "1001" => decoded <= "1110011";
	when others => decoded <= "0000000";
	end case;
end process findNumber;
end architecture behave;
	




