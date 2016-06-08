-- alafsm.vhd					AJM : 25.11.2002
--
-- entity	alafsm	-alarm state-machine
-- architecture	
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity alafsm is
  port( reset		: in  std_logic;	--async. reset		L
	clk1ms		: in  std_logic;	--1KHz clock		R
	alarm_tog	: in  std_logic;	--toggle-alarm		H
	compare		: in  std_logic;	--is alarm time		H
	alarm_act	: out std_logic;	--alarm LED on		H
	alarm_out	: out std_logic);	--alarm ringer		H
end entity alafsm;

architecture BEHAVIOR of alafsm is
	type	STATE_TYPE is (IDLE, IDLE_TOG, WAITING, WAITING_TOG, ALARM, ALARMI_TOG);
	signal CURR_STATE, NEXT_STATE	: STATE_TYPE;
begin
	
	COMBIN: process (CURR_STATE, alarm_tog, compare) is 
	begin
		case CURR_STATE is
			when IDLE => alarm_act <= '0';
									 alarm_out <= '0';
									 If alarm_tog = '0' then		NEXT_STATE <= IDLE;
									 else 											NEXT_STATE <= IDLE_TOG;
									 end if;

			when IDLE_TOG => alarm_act <= '0';
											 alarm_out <= '0';
											 if alarm_tog = '0' then		NEXT_STATE <= WAITING;
											 else												NEXT_STATE <= IDLE_TOG;
											 end if;

			when WAITING => alarm_act <= '1';
											alarm_out <= '0';
											if alarm_tog = '0' then		NEXT_STATE <= WAITING;
											else											NEXT_STATE <= WAITING_TOG;
 											end if;
											if compare = '1' then		NEXT_STATE <= ALARM;
											else										NEXT_STATE <= WAITING;
											end if;

			when WAITING_TOG => alarm_act <= '0';
													alarm_out <= '0';
													if alarm_tog = '0' then		NEXT_STATE <= IDLE;
													else 											NEXT_STATE <= WAITING_TOG;
													end if;  

			when ALARM => alarm_act <= '1';
										alarm_out <= '1';
										if alarm_tog = '0' then		NEXT_STATE <= ALARM;
										else 											NEXT_STATE <= ALARMI_TOG;													 
									 	end if;

			when ALARMI_TOG => alarm_act <= '0';
					 							alarm_out <= '0';
												if alarm_tog = '0' then		NEXT_STATE <= IDLE;
												else											NEXT_STATE <= ALARMI_TOG;
												end if;
    end case;
  end process COMBIN;
 
  SYNCH: process (reset,clk1ms) is
	begin
		if reset = '0' then		CURR_STATE <= IDLE;
		elsif rising_edge(clk1ms) then          CURR_STATE <= NEXT_STATE;
    end if;
  end process SYNCH;
end architecture BEHAVIOR;

		

