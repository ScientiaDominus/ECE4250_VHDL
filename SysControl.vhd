library IEEE;
use IEEE.std_logic_1164.all;
use work.array_type.all;

-------------------------------------------------------------
--This machine will be further implemented to use more than a couple bits for encoding. This will allow for multiple states to be encoded and
--proper state machine implementation.

entity StateMachine is 
	port(MemCheck, CalcDone, StoreDone, CLK: in std_logic;
		Load_Mem, Calc_Start, Store_Mem, clear_mem: out std_logic);
end StateMachine;

architecture structure of StateMachine is
signal State: integer range 0 to 4 := 0;
begin 
	process(CLK)
	begin
		if CLK'event and CLK = '1' then 
			case State is
				when 0 => --Wait State, waits until memory has input matrices
					if  MemCheck = '1' then State <= 1;
					elsif MemCheck = '0' then State <= 0;
					end if;
				when 1 => --This state loads the weights and activations into memory and prepares the systolic array for clearing.
					State <= 2;
				when 2 => --This state clears the processing elements and prepares the systolic array for computation.
					State <= 3;
				when 3 => --Calc State, waits until memory is found then triggers the calculation state
					if CalcDone = '1' then State <= 4;
					elsif CalcDone = '0' then State <= 3;
					end if;
				when 4 => --Done State, Checks if the calculations are done and signals to store the result and start looking for more inputs.
					if StoreDone = '1' then State <= 0;
					elsif StoreDone = '0' then State <= 4;
					end if;
			end case;
		end if;
	end process;
	Load_Mem <= '1' when (State = 1) and (MemCheck = '0')
		else '0';
	clear_mem <= '1' when (State = 2)
		else '0';
	Calc_Start <= '1' when (State = 3)
		else '0';
	Store_Mem <= '1' when (State = 4) and (StoreDone = '0')
		else '0';
end structure;