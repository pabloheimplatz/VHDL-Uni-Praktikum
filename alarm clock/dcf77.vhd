-- dcf77.vhd					AJM : 25.11.2002
--
-- entity	dcf77	-DCF77 sender
--			-(optional) preset signals and noise
-- architecture	behavior
--
-- note		Simulating noisy input, the uniform function from
--		ieee.math_real is used.			-> ncsim, leapfrog
--		This package is not (fully) implemented for Synopsys!
--		Use synopsys.distributions instead	-> scirocco, vss	
------------------------------------------------------------------------------
-- library synopsys;		-- Synopsys
-- use synopsys.distributions.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;		-- IEEE 1076.2

entity dcf77 is
generic (	tDelay	: time		:= 300 us;	-- initial Delay
		tSample	: time		:=   1 ms);	-- 1 kHz sample freq.
port	(	dcfsig	: out std_logic;		-- DCF77 signal
		mins	: in  integer range 0 to 59	:= 34;
		hours	: in  integer range 0 to 23	:= 12;
		wday	: in  integer range 1 to  7	:= 1;
		day	: in  integer range 1 to 31	:= 25;
		month	: in  integer range 1 to 12	:= 11;
		year	: in  integer range 0 to 99	:= 2;
		noise	: in  integer range 0 to 50	:= 0;
		xtra	: in  std_logic_vector (15 to 19):= "00000");
end entity dcf77;

architecture behavior of dcf77 is
  constant samp100ms	: integer	:= 100 ms/tSample; -- ticks per 100 ms

  function  dcfVec (	arg	: natural;
			size	: positive)
			return	  std_logic_vector is
    variable	retVal		: std_logic_vector (1 to size);
    variable	tmp		: natural := arg;
  begin
    for i in retVal'range loop
      if (tmp mod 2) = 0	then	retVal(i) := '0';
				else	retVal(i) := '1';
      end if;
      tmp := tmp / 2;
    end loop;
    return retVal;
  end function dcfVec;

  function  parity (	vec	: std_logic_vector )
			return	  std_logic is
    variable	retVal		: std_logic := '0';
  begin
    for i in vec'range loop
      retVal := retVal xor vec(i);
    end loop;
    return retVal;
  end function parity;

begin
  dcfP: process
    variable minCnt, hourCnt	: integer;
    variable dcfString		: std_logic_vector(0 to 58);
--    variable synSeed		: real				:= 1.82736459;
    variable seed1		: positive			:= 123456789;
    variable seed2		: positive			:= 8273645;
    variable random		: real;
  begin
    dcfsig  <= '1';
    wait for tDelay;
    minCnt  := mins;
    hourCnt := hours;

    -- dcfString: initial formatting	--------------------------------------
    --------------------------------------------------------------------------
    dcfString( 0 to 14)	:= (others=>'0');
    dcfString(15 to 19)	:= xtra;
    dcfString(20)	:= '1';
    dcfString(21 to 24)	:= dcfVec(minCnt rem 10, 4);
    dcfString(25 to 27)	:= dcfVec(minCnt  /  10, 3);
    dcfString(28)	:= parity(dcfString(15 to 27));
    dcfString(29 to 32)	:= dcfVec(hourCnt rem 10, 4);
    dcfString(33 to 34)	:= dcfVec(hourCnt  /  10, 2);
    dcfString(35)	:= parity(dcfString(29 to 34));
    dcfString(36 to 39)	:= dcfVec(day rem 10, 4);
    dcfString(40 to 41)	:= dcfVec(day  /  10, 2);
    dcfString(42 to 44)	:= dcfVec(wday, 3);
    dcfString(45 to 48)	:= dcfVec(month rem 10, 4);
    if (month / 10) = 1	then dcfString(49) := '1';
			else dcfString(49) := '0';
    end if;
    dcfString(50 to 53)	:= dcfVec(year rem 10, 4);
    dcfString(54 to 57)	:= dcfVec(year  /  10, 4);
    dcfString(58)	:= parity(dcfString(36 to 57));

    -- loop forever			--------------------------------------
    --------------------------------------------------------------------------
    loop
      if noise = 0 then			-- zero noise
	for i in dcfString'range loop	-- second loop
	  if dcfString(i) = '1'	then	dcfsig <= '0';
					wait for 200 ms;
					dcfsig <= '1';
					wait for 800 ms;
				else	dcfsig <= '0';
					wait for 100 ms;
					dcfsig <= '1';
					wait for 900 ms;
	  end if;
	end loop;			-- second loop

      else				-- noise% errors at '0' level
	for i in dcfString'range loop	-- second loop
	  if dcfString(i) = '1'	then		-- noisy '1'
		for s in 1 to 2*samp100ms loop	-- '0'-level
--		  uniform(synSeed, 0.0, 100.0, random);
--		  if random < real(noise)
		  uniform(seed1, seed2, random);
		  if random*100.0 < real(noise)
			then	dcfsig <= '1';
			else	dcfsig <= '0';
		  end if;
		  wait for tSample;
		end loop;			-- '0'-level
					dcfsig <= '1';
					wait for 800 ms;

	  else					-- noisy '0'
		for s in 1 to samp100ms loop	-- '0'-level
--		  uniform(synSeed, 0.0, 100.0, random);
--		  if random < real(noise)
		  uniform(seed1, seed2, random);
		  if random*100.0 < real(noise)
			then	dcfsig <= '1';
			else	dcfsig <= '0';
		  end if;
		  wait for tSample;
		end loop;			-- '0'-level
					dcfsig <= '1';
					wait for 900 ms;
	  end if;
	end loop;			-- second loop
      end if;				-- random noise

      -- increment time			--------------------------------------
      if minCnt = 59
	then	minCnt := 0;
		if hourCnt = 23	then	hourCnt := 0;
				else	hourCnt := hourCnt + 1;
		end if;
	else	minCnt := minCnt + 1;
      end if;

      -- dcfString: formatting		--------------------------------------
      dcfString(21 to 24) := dcfVec(minCnt rem 10, 4);
      dcfString(25 to 27) := dcfVec(minCnt  /  10, 3);
      dcfString(28)	  := parity(dcfString(15 to 27));
      dcfString(29 to 32) := dcfVec(hourCnt rem 10, 4);
      dcfString(33 to 34) := dcfVec(hourCnt  /  10, 2);
      dcfString(35)	  := parity(dcfString(29 to 34));

      wait for 1 sec;			-- last second
    end loop;				-- forever
  end process dcfP;
end architecture behavior;

-- sample usage		------------------------------------------------------
------------------------------------------------------------------------------
--library ieee;
--use ieee.std_logic_1164.all;
--
--entity xxx is
--end entity xxx;
--architecture tst of xxx is
--component dcf77 is
--generic (	tDelay	: time		:= 300 us;	-- initial Delay
--		tSample	: time		:=   1 ms);	-- 1 kHz sample freq.
--port	(	dcfsig	: out std_logic;		-- DCF77 signal
--		mins	: in  integer range 0 to 59	:= 34;
--		hours	: in  integer range 0 to 23	:= 12;
--		wday	: in  integer range 1 to  7	:= 1;
--		day	: in  integer range 1 to 31	:= 25;
--		month	: in  integer range 1 to 12	:= 11;
--		year	: in  integer range 0 to 99	:= 2;
--		noise	: in  integer range 0 to 50	:= 0;
--		xtra	: in  std_logic_vector (15 to 19):= "00000");
--end component dcf77;
--  signal xxx : std_logic;
--begin
--  sendI: dcf77 port map (xxx);
--end architecture tst;
