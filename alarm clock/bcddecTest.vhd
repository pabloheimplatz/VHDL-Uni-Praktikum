library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcddecTest is
generic(	periodC	: time		:= 10 ns;
		cyclesC	: integer	:= 100);
end entity bcddecTest;

architecture testbench of bcddecTest is

  component bcddec is
  port( bcdin	: in  std_logic_vector (3 downto 0);  --BCD input      MSB-left
	decoded	: out std_logic_vector (6 downto 0)); --7 Seg. output  a..g
  end component bcddec;
	
  signal bcdin	 : std_logic_vector (3 downto 0);  --BCD input      MSB-left
  signal decoded : std_logic_vector (6 downto 0); --7 Seg. output  a..g

begin 
 Uut: bcddec port map (bcdin, decoded);

   process is
	begin
	    
	for i in 0 to 15 loop
	  bcdin <= std_logic_vector(to_unsigned(i, 4));
	wait for 10 ms;	
	end loop;
	wait;
   end process;

end architecture testbench;
