library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- The accumulator accumulates values over time as the result matrix is calculated
-- Accumulator:
--      inputs:
--          std_logic:
--              clr: This is passed down from the parent device to signal clearing operations
--              clk: This is a simple clock signal to regulate operations in a logical manner
--              CalcDone: This is passed down by the parent device to signal when the accumulator should shift the values by its index.
--              Calc_Start: This is passed down by the parent device to signal that the calculation is beginning and to switch the accumulator to shift every cycle behavior
--              ShiftOnce: This signal also signals the device to shift once per cycle but is only used in a special case for storing the values found in the accumulator
--          integer:
--              InValue: This is the value that is port mapped to its corresponding element in the systolic array, this is fed in and stored each cycle
--      outputs:
--          std_logic:
--              StoreDone: This output is set to 1 when the post calculation shift is finished and the values have been stored in the accumulators. 
--          integer:
--              OutValue: This output is always the final value in the AccArray and is updated every clock cycle. This is done regardless of other inputs. 
-- Functionality:
--      The accumulator is designed to receive inputs and shift them each cycle to allow for the accumulation of the result values from the systolic array. It employs a number of 
--      special behaviors based on the implementation used which includes the special shifting algorithm and based off the index and the shift_once functionality that operates only
--      during a specific portion of the calculation.     
entity accumulator is
    generic(index: integer range 0 to 256;
            N: integer range 0 to 256);
    port(
        clr, clk, CalcDone, Calc_Start, ShiftOnce: in std_logic;
        InValue: in integer;
        OutValue: out integer;
        StoreDone: out std_logic
    );
end accumulator;

architecture Structure of accumulator is

type int_array is array(0 to (2*N -1)) of integer;
signal AccArray: int_array;                         -- This is the core of the accumulator, it stores all the values and is shifted when necessary. This can change size at compile time 
                                                    -- based on the generic input. 
begin
process(clk)
    variable run_counter: integer := 0;         -- This simply exists to allow the accumulator to be filled with 0's at the start of the run cycle. 
    variable shift_counter: integer := 0;       -- This is a counter that allows the accumulator to keep track of the times it has shifted so that it shifts the proper number of times

    begin
    if (run_counter = 0) then                   -- This loop clears the accumulator of garbage values at the start of the program. This ensures proper storage of the values at run time
        for i in (2*N -1) downto 0 loop
            AccArray(i) <= 0;
        end loop;
        run_counter := run_counter + 1;

    elsif clk'event and clk = '1' then
        if(CalcDone = '1' and ShiftOnce /= '1') then    -- This loop shifts the accumulator by a specific amount determined by its index in the called function. i.e. the accumulator will
            if (shift_counter < index) then             -- shift only once during this loop if its index is 1 and will shift twice if its index is 2 or thrice if the index is 3 etc.
                for i in (2*N -1) downto 0 loop
                    if(i = 0) then
                        AccArray(i) <= 0;               -- This sets the first value of the AccArray to 0 when the index is 0. This ensures that no extraneous values are stored in the accumulator
                    else
                        AccArray(i) <= AccArray(i - 1); -- This is the actual shifting logic, it swaps the value at i with the value at i - 1. This doesn't need a temp value due to delta time in real hardware
                    end if;
                end loop; -- shiftloop
                shift_counter := shift_counter + 1;

            elsif(shift_counter = index) then
                StoreDone <= '1'; 
            end if;

        elsif(Calc_Start = '1' and CalcDone = '0') then
            for i in (2*N - 1) downto 0 loop
                if(i = 0) then                          -- This loop operates when the calculation is being run for the matrix multiplication. This will update the first value in the
                    AccArray(i) <= InValue;             -- AccArray with the Sum out signal that is port mapped to its invalue port in systolic array. This ensures that while the 
                else                                    -- Calculation is occuring the values are properly stored within the array. This loop also shifts the accumulator after every
                    AccArray(i) <= AccArray(i - 1);     -- clock cycle to ensure that no values are overwritten and the result is stored in a matrix format. 
                end if;
            end loop; -- clocked loop for calculations

        elsif(shiftOnce = '1') then
            for i in (2*N - 1) downto 0 loop            -- This loop operates the same as the previous loop but only shifts the array every clock cycle until the result is properly stored
                if(i = 0) then                          -- this prevents the program from shifting the wrong number of times after the calculation is complete. 
                    AccArray(i) <= InValue;
                else
                    AccArray(i) <= AccArray(i - 1);
                end if;
            end loop;
        end if;

        OutValue <= AccArray((2*N-1)); --set the outvalue as the last element of the accumulator
        run_counter := 1;
    end if;
end process;
end Structure;
