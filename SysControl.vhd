library IEEE;
use IEEE.std_logic_1164.all;

-------------------------------------------------------------
--This machine will be further implemented to use more than a couple bits for encoding. This will allow for multiple states to be encoded and
--proper state machine implementation.

entity StateMachine is 
	port(X, Y, CLK: in std_logic;
		Z: out std_logic_vector(1 downto 0));
end StateMachine;

architecture structure of StateMachine is
signal State: integer range 0 to 3 := 0;
begin 
	process(CLK)
	begin
		if CLK'event and CLK = '1' then 
			case State is
				when 0 => 
					if X = '0' and Y = '0' then State <= 0;
					elsif X = '0' and Y = '1' then State <= 1;
					elsif X = '1' and Y = '0' then State <= 2;
					elsif X = '1' and Y = '1' then State <= 1;
					end if;
				when 1 =>
					if X = '0' and Y = '0' then State <= 1;
					elsif X = '0' and Y = '1' then State <= 0;
					elsif X = '1' and Y = '0' then State <= 2;
					elsif X = '1' and Y = '1' then State <= 3;
					end if;
				when 2 =>
					if X = '0' and Y = '0' then State <= 2;
					elsif X = '0' and Y = '1' then State <= 3;
					elsif X = '1' and Y = '0' then State <= 3;
					elsif X = '1' and Y = '1' then State <= 1;
					end if;
				when 3 =>
					if X = '0' and Y = '0' then State <= 3;
					elsif X = '0' and Y = '1' then State <= 0;
					elsif X = '1' and Y = '0' then State <= 1;
					elsif X = '1' and Y = '1' then State <= 0;
					end if;
			end case;
		end if;
	end process;
	Z <= '1' when (State = 2) or (State = 3)
		else '0';
end structure;