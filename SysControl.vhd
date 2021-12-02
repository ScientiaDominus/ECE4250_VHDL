library IEEE;
use IEEE.std_logic_1164.all;
use work.array_type.all;

-- StateMachine is used to indicate what operation should currently be performed.
-- There are 5 states. wait -> initialize array -> clear PE's -> calculate -> done

entity StateMachine is
	port(MemCheck, CalcDone, StoreDone, CLK: in std_logic;
		Calc_Start, Store_Mem, clear_mem: out std_logic);
end StateMachine;

architecture structure of StateMachine is
signal State: integer range 0 to 3 := 0;    -- Signal used to store the current state

begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			case State is
				when 0 => --Wait State, waits until memory has input matrices
					if  MemCheck = '1' then State <= 1;
					elsif MemCheck = '0' then State <= 0;
					end if;
				when 1 => --This state clears the processing elements and prepares the systolic array for computation.
					State <= 2;
				when 2 => --Calc State, waits until memory is found then triggers the calculation state
					if CalcDone = '1' then State <= 3;
					elsif CalcDone = '0' then State <= 2;
					end if;
				when 3 => --Done State, Checks if the calculations are done and signals to store the result and start looking for more inputs.
					if StoreDone = '1' then State <= 0;
					elsif StoreDone = '0' then State <= 3;
					end if;
			end case;
		end if;
	end process;
	clear_mem <= '1' when (State = 1)
		else '0';
	Calc_Start <= '1' when (State = 2)
		else '0';
	Store_Mem <= '1' when (State = 3) and (StoreDone = '0')
		else '0';
end structure;
